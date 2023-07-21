import UIKit
import Kingfisher

final class StatNFTCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    let ratingView = RatingView()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noLikeIcon"), for: .normal)
        
        button.tintColor = .appLightGrey
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var bucketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addToCart"), for: .normal)
        button.tintColor = UIColor.appBlack
        button.addTarget(self, action: #selector(bucketTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var imageBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .appWhite
        return view
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

extension StatNFTCell {
    func configure(with nft: Nft?) {
        nameLabel.text = nft?.name
        ratingView.set(length: nft?.rating ?? 0)
        
        if let price = nft?.price {
            priceLabel.text = String(price)
        } else {
            priceLabel.text = "?"
        }
        
        
        guard let url = nft?.images[0], let validUrl = URL(string: url) else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        imageBackground.kf.setImage(with: validUrl, options: options)
    }
    
}

private extension StatNFTCell {
    @objc func likeTapped() {
        print("likeTapped")
        likeButton.setImage(UIImage(named: "likeIcon"), for: .normal)
       
    }
    
    @objc func bucketTapped() {
        print("buckeTapped")
    }
    
}

private extension StatNFTCell {
    func setupAppearance() {
        contentView.addSubview(imageBackground)
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(bucketButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackground.heightAnchor.constraint(equalTo: widthAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: imageBackground.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageBackground.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            bucketButton.widthAnchor.constraint(equalToConstant: 40),
            bucketButton.heightAnchor.constraint(equalToConstant: 40),
            bucketButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 0),
            bucketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            priceLabel.heightAnchor.constraint(equalToConstant: 12)
            
        ])
    }
}