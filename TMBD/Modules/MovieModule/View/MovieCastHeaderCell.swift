import UIKit

final class MovieCastHeaderCell: UICollectionViewCell {
    //MARK: - Property
    static let identifire = "HeaderCastCell"

    var castTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "Cast"
        return titleLabel
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(castTitleLabel)
    }

    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraint()
    }

    //MARK: - Constraints
    func addConstraint() {
        NSLayoutConstraint.activate([
            castTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            castTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            castTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
