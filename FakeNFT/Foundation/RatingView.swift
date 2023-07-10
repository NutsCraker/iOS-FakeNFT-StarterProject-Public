
import UIKit

final class RatingView: UIView {
    lazy private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.spacing = 2
        stack.alignment = .center
        stack.distribution = .fillEqually

        return stack
    }()

    private let maximumStars = 5

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func set(length: Int) {
        guard length >= 0 && length <= maximumStars else { return }

        for index in 0..<maximumStars {
            stackView.arrangedSubviews[index].tintColor = index < length
                ? .asset(.yellow)
                : .asset(.lightGray)
        }
    }

    // MARK: - Private methods

    private func setupView() {
        let starImage = UIImage(systemName: "star.fill")

        for _ in 0..<maximumStars {
            let starImageView = UIImageView(image: starImage)
            starImageView.tintColor = .asset(.lightGray)
            stackView.addArrangedSubview(starImageView)

            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 11.25)
            ])
        }

        addSubview(stackView)
    }
}
