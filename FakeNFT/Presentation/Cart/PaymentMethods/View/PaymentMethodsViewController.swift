//
//  PaymentMethodsViewController.swift
//  FakeNFT
//
//  Created by Anton Vikhlyaev on 14.07.2023.
//

import UIKit

protocol PaymentMethodsViewProtocol: AnyObject {
    func updateUI()
    func showViewController(_ vc: UIViewController)
    func showProgressHUB()
    func dismissProgressHUB()
}

final class PaymentMethodsViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let titleLabelText = Localization.cartTitleLabelText
        static let paymentButtonText = Localization.cartPaymentButtonText
        static let descriptionLabelText = Localization.cartDescriptionLabelText
        static let agreementLinkLabelText = Localization.cartAgreementLinkLabelText
    }
    
    // MARK: - Properties
    
    private let presenter: PaymentMethodsPresenterProtocol
    
    // MARK: - UI
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Image.iconBack.image, for: .normal)
        button.tintColor = Image.appBlack.color
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleLabelText
        label.textAlignment = .center
        label.textColor = Image.appBlack.color
        label.font = .bold17
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = Image.appWhite.color
        collectionView.register(PaymentMethodsCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = Image.appLightGrey.color
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.descriptionLabelText
        label.font = .regular13
        label.textColor = Image.appBlack.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agreementLinkLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.agreementLinkLabelText
        label.font = .regular13
        label.textColor = Image.customBlue.color
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gestureRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Image.appBlack.color
        button.layer.cornerRadius = 16
        button.setTitle(Constants.paymentButtonText, for: .normal)
        button.titleLabel?.font = .bold17
        button.tintColor = Image.appWhite.color
        button.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(agreementLinkLabelTapped))
    
    // MARK: - Life Cycle
    
    init(presenter: PaymentMethodsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
        presenter.viewIsReady()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = Image.appWhite.color
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(descriptionLabel)
        bottomView.addSubview(agreementLinkLabel)
        bottomView.addSubview(paymentButton)
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func paymentButtonTapped() {
        presenter.didTapPaymentButton()
    }
    
    @objc
    private func agreementLinkLabelTapped() {
        presenter.didTapAgreementLinkLabel()
    }
}

// MARK: - PaymentMethodsViewProtocol

extension PaymentMethodsViewController: PaymentMethodsViewProtocol {
    func updateUI() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func showViewController(_ vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func showProgressHUB() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgressHUB() {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UICollectionViewDataSource

extension PaymentMethodsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter.numberOfItemsInSection
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: PaymentMethodsCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: presenter.getCurrency(at: indexPath))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentMethodsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (collectionView.frame.width / 2) - 7, height: 46)
    }
}

// MARK: - UICollectionViewDelegate

extension PaymentMethodsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? PaymentMethodsCell
        else { return }
        paymentButton.isEnabled = true
        cell.setSelected(true)
        presenter.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? PaymentMethodsCell
        else { return }
        cell.setSelected(false)
    }
}

// MARK: - Setting Constraints

extension PaymentMethodsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -57),
            
            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -16),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            
            descriptionLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            agreementLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            agreementLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLinkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
