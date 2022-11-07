import UIKit

class MainSerialCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property
    static let identifire = "SerialCell"
    
    var serialImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    var serialTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    var serialDataLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.font = .systemFont(ofSize: 14)
        dataLabel.textColor = .lightText
        return dataLabel
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(serialImageView, serialTitleLabel, serialDataLabel)
    }
    
    //MARK: - LayoutSubviews
        
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraint()
    }
    
    //MARK: - Constraints
    func addConstraint() {
        NSLayoutConstraint.activate([
            serialImageView.topAnchor.constraint(equalTo: self.topAnchor),
            serialImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            serialImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            serialImageView.heightAnchor.constraint(equalToConstant: self.frame.height),

            serialTitleLabel.topAnchor.constraint(equalTo: serialImageView.bottomAnchor, constant: 10),
            serialTitleLabel.centerXAnchor.constraint(equalTo: serialImageView.centerXAnchor),
            serialTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            serialTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            serialDataLabel.topAnchor.constraint(equalTo: serialTitleLabel.bottomAnchor, constant: 2),
            serialDataLabel.centerXAnchor.constraint(equalTo: serialImageView.centerXAnchor),
            serialDataLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            serialDataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
