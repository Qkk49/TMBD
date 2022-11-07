import UIKit

final class MainMovieCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property
    static let identifire = "MovieCell"
    
    var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    var movieTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    var movieDataLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.font = .systemFont(ofSize: 14)
        dataLabel.textColor = .lightText
        return dataLabel
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(movieImageView, movieTitleLabel, movieDataLabel)
    }
    
    //MARK: - LayoutSubviews
        
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraint()
    }
    
    //MARK: - Constraints
    func addConstraint() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: self.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: self.frame.height),

            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            movieTitleLabel.centerXAnchor.constraint(equalTo: movieImageView.centerXAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            movieDataLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 2),
            movieDataLabel.centerXAnchor.constraint(equalTo: movieImageView.centerXAnchor),
            movieDataLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieDataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
