import UIKit

final class SerialCastCollectionViewCell: UICollectionViewCell {
    //MARK: - Property
    static let identifire = "CastCell"
    
    var castImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    var castNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 9)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    var castCharacterLabel: UILabel = {
        let characterLabel = UILabel()
        characterLabel.font = .systemFont(ofSize: 9)
        characterLabel.textColor = .lightText
        return characterLabel
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(castImageView, castNameLabel, castCharacterLabel)
    }
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraint()
    }
    
    //MARK: - Constraints
    func addConstraint() {
        NSLayoutConstraint.activate([
            castImageView.topAnchor.constraint(equalTo: self.topAnchor),
            castImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            castImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            castImageView.heightAnchor.constraint(equalToConstant: self.frame.height),

            castNameLabel.topAnchor.constraint(equalTo: castImageView.bottomAnchor, constant: 10),
            castNameLabel.centerXAnchor.constraint(equalTo: castImageView.centerXAnchor),
            castNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            castNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            castCharacterLabel.topAnchor.constraint(equalTo: castNameLabel.bottomAnchor, constant: 2),
            castCharacterLabel.centerXAnchor.constraint(equalTo: castImageView.centerXAnchor),
            castCharacterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            castCharacterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
