import UIKit
import Kingfisher

final class MovieCell: UICollectionViewCell {
    private lazy var imageView = UIImageView()
    private lazy var ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        ratingLabel.text = ""
    }

    func fillData(imageURL: URL?, rating: String) {
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            if case .success = result {
                self?.ratingLabel.text = rating
            }
        }
    }
}

// MARK: - Private methods

extension MovieCell {
    private func setup() {
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15

        ratingLabel.layer.masksToBounds =  true
        ratingLabel.layer.cornerRadius = 20
        ratingLabel.backgroundColor = .systemYellow
        ratingLabel.font = .systemFont(ofSize: 17, weight: .bold)
        ratingLabel.textColor = .white
        ratingLabel.textAlignment = .center

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true

        contentView.addSubview(ratingLabel)
        ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        ratingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        ratingLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
}

