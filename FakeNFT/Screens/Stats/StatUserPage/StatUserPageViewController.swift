import UIKit
import Kingfisher

final class StatUserPageViewController: UIViewController {
    private var viewModel: StatUserPageViewModel!
    private let submitButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    private let userId: String

    override func viewDidLoad() {
        super.viewDidLoad()
        let model = StatUserPageModel()
        viewModel = StatUserPageViewModel(model: model)
        viewModel.onChange = configure
        viewModel.onChange = { [weak self] in
            self?.configure()
        }
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(title: "Ошибка при загрузке данных пользователя", message: error.localizedDescription, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default) { _ in
                   retryAction()
               })
               alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
               self?.present(alert, animated: true, completion: nil)
        }
        viewModel.getUser(userId: userId)
        setupAppearance()
        view.backgroundColor = .asset(.white)
    }

    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true

        return view
    }()

    private lazy var descriptionView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .asset(.black)
        label.font = .caption2

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var siteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.asset(.black), for: .normal)
        button.titleLabel?.font = .caption1

        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.tintColor = .clear
        button.layer.borderColor = UIColor.asset(.black).cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var collectionButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Коллекция NFT"
        label.textColor = .asset(.black)
        label.font = .bodyBold
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var collectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        let iconImageView = UIImageView(image: UIImage(named: "rightArrow"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        stackView.addArrangedSubview(collectionButtonLabel)
        stackView.addArrangedSubview(iconImageView)

        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNFTCollection))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true

        return button
    }()

    func configure() {
        guard let user = viewModel.user else {return}
        guard  let validUrl = URL(string: user.avatar) else {return}
        let imageSize = CGSize(width: 70, height: 70)
        let placeholderSize = CGSize(width: 70, height: 70)
        let processor = RoundCornerImageProcessor(cornerRadius: imageSize.width / 2)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]

        avatarView.kf.setImage(with: validUrl, placeholder: UIImage(named: "avatar")?.kf.resize(to: placeholderSize), options: options) { result in
             switch result {
             case .success(let value):
                 DispatchQueue.main.async { [weak self] in
                     self?.avatarView.image = value.image
                     self?.avatarView.layer.cornerRadius = imageSize.width / 2
                     self?.avatarView.layer.masksToBounds = true
                 }
             case .failure(let error):
                 print("Image download failed: \(error)")
                 let alert = UIAlertController(title: "Ошибка при загрузке аватара", message: error.localizedDescription, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default) { _ in
                       self.viewModel.getUser(userId: self.userId)
                   })
                   alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                   self.present(alert, animated: true, completion: nil)
             }
         }
        nameView.text = user.name
        descriptionView.text = user.description
        collectionButtonLabel.text = "Коллекция NFT (\(user.nfts.count))"
        collectionButtonLabel.tintColor = .asset(.black)
    }

    @objc
    private func openWebView() {
        guard let siteUrl = viewModel.user?.website, let url = URL(string: siteUrl) else {
            return
        }

        let webView = WebViewService(url: url)
        navigationController?.pushViewController(webView, animated: true)
    }

    @objc
    private func openNFTCollection() {
        let collectionModel = StatUserCollectionPageModel()
        let collectionViewModel = StatUserCollectionPageViewModel(model: collectionModel, ids: viewModel.user?.nfts)
        let viewController = StatUserCollectionPageViewController(viewModel: collectionViewModel)
        viewController.title = "Коллекция NFT"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(viewController, animated: true)
    }

    func setupAppearance() {
        view.backgroundColor = .asset(.white)

        view.addSubview(avatarView)
        view.addSubview(nameView)
        view.addSubview(descriptionView)
        view.addSubview(siteButton)
        view.addSubview(collectionButton)

        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),

            descriptionView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            siteButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            siteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            siteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),

            collectionButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 56),
            collectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
