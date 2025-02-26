//
//  PaymentMethodsCell.swift
//  FakeNFT
//
//  Created by Anton Vikhlyaev on 14.07.2023.
//

import UIKit

final class PaymentMethodsCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = Image.appLightGrey.color
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = Image.appBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = Image.customGreen.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupCell() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(currencyImageView)
        wrapperView.addSubview(currencyNameLabel)
        wrapperView.addSubview(currencyShortNameLabel)
    }
    
    // MARK: - Configure
    
    func configure(with currency: Currency) {
        currencyNameLabel.text = currency.title
        currencyShortNameLabel.text = currency.name
        currencyImageView.image = UIImage(named: "icon-\(currency.name.lowercased())")
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            wrapperView.layer.borderWidth = 1
            wrapperView.layer.borderColor = Image.appBlack.color.cgColor
        } else {
            wrapperView.layer.borderWidth = 0
        }
    }
}

// MARK: - Setting Constraints

extension PaymentMethodsCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            currencyImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 5),
            currencyImageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            currencyImageView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            
            currencyNameLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 5),
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyNameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -12),
            
            currencyShortNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyShortNameLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -12),
            currencyShortNameLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5)
        ])
    }
}
