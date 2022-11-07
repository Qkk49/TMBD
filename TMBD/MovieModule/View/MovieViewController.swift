import UIKit
import Kingfisher
import Cosmos

class MovieViewController: UIViewController {
    
    //MARK: - Property
    var presenter: MovieViewPresenterProtocol!
    
    var mainImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.72
        return imageView
    }()
    
    var movieNameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    var movieInfoLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.textColor = .lightText
        return infoLabel
    }()
    
    lazy var movieBackButton: UIButton = {
        var backButton = UIButton()
        var imageButton = UIImage(named: "backArrow")
        backButton.setImage(imageButton, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return backButton
    }()
    
    var movieRating: UIView = {
        var rating = UIView()
        return rating
    }()
    
    var movieTextRating: UILabel = {
        var textRating = UILabel()
        textRating.font = .systemFont(ofSize: 20)
        textRating.textColor = .systemYellow
        return textRating
    }()
    
    var movieStarRating: CosmosView = {
        var starRating = CosmosView()
        starRating.settings.fillMode = .precise
        starRating.settings.emptyColor = .lightText
        starRating.settings.filledBorderColor = .systemYellow
        starRating.settings.emptyBorderColor = .lightText
        starRating.settings.starSize = 20
        starRating.settings.starMargin = 5
        starRating.settings.filledColor = .systemYellow
        return starRating
    }()
    
    var movieOverview: UILabel = {
        var overview = UILabel()
        overview.font = .systemFont(ofSize: 16)
        overview.textColor = .lightText
        overview.numberOfLines = 5
        return overview
    }()
    
    var movieCastTitle: UILabel = {
        var castTitle = UILabel()
        castTitle.text = "Cast"
        castTitle.font = .boldSystemFont(ofSize: 20)
        castTitle.textColor = .white
        return castTitle
    }()
    
    var movieCastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let castView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        castView.register(MovieCastCollectionViewCell.self, forCellWithReuseIdentifier: MovieCastCollectionViewCell.identifire)
        castView.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.0)
        return castView
    }()
    
    lazy var movieToWebButton: UIButton = {
        var webButton = UIButton()
        webButton.backgroundColor = .red
        webButton.setTitle("Watch Now", for: .normal)
        webButton.layer.cornerRadius = 10
        webButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        webButton.titleLabel?.textColor = .white
        webButton.addTarget(self, action: #selector(toWeb), for: .touchUpInside)
        return webButton
    }()
    
    //MARK: - LoadView
    override func loadView() {
        super.loadView()
        presenter.getThisMovie(id: presenter.trend!)
        presenter.getThisCast(id: presenter.trend!)
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.43)
        movieRating.addSubviews(movieTextRating, movieStarRating)
        view.addSubviews(mainImage, movieBackButton, movieNameLabel, movieInfoLabel, movieRating, movieOverview, movieCastTitle, movieCastCollectionView, movieToWebButton)
        addConstraints()
        createLayout()
        movieCastCollectionView.dataSource = self
    }
    
    //MARK: - Create Layout
    private func createLayout() {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 6.7),
            heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous

        let layout = UICollectionViewCompositionalLayout(section: section)
        movieCastCollectionView.collectionViewLayout = layout
    }
    
    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            movieBackButton.topAnchor.constraint(equalTo: mainImage.topAnchor),
            movieBackButton.heightAnchor.constraint(equalTo: mainImage.heightAnchor, multiplier: 0.15),
            movieBackButton.widthAnchor.constraint(equalTo: mainImage.widthAnchor, multiplier: 0.15),
            
            movieNameLabel.bottomAnchor.constraint(equalTo: movieInfoLabel.topAnchor, constant: -4),
            movieNameLabel.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor),
            
            movieInfoLabel.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -8),
            movieInfoLabel.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor),
            
            movieRating.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 18),
            movieRating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            movieTextRating.leadingAnchor.constraint(equalTo: movieRating.leadingAnchor),
            movieTextRating.centerYAnchor.constraint(equalTo: movieRating.centerYAnchor),
            movieTextRating.trailingAnchor.constraint(equalTo: movieStarRating.leadingAnchor, constant: -8),
            
            movieStarRating.trailingAnchor.constraint(equalTo: movieRating.trailingAnchor),
            movieStarRating.centerYAnchor.constraint(equalTo: movieRating.centerYAnchor),
            
            movieOverview.topAnchor.constraint(equalTo: movieRating.bottomAnchor, constant: 16),
            movieOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            movieOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            movieCastTitle.topAnchor.constraint(equalTo: movieOverview.bottomAnchor, constant: 16),
            movieCastTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            movieCastTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            movieCastCollectionView.topAnchor.constraint(equalTo: movieCastTitle.bottomAnchor),
            movieCastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCastCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            movieToWebButton.topAnchor.constraint(equalTo: movieCastCollectionView.bottomAnchor),
            movieToWebButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            movieToWebButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            movieToWebButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func back(sender: UIButton) {
        presenter.tap()
    }
    
    @objc func toWeb(sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://www.themoviedb.org/movie/" + String(presenter.trend!))! as URL)
    }
}

//MARK: - Collection DataSource
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(10, presenter.casts?.cast.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieCastCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCastCollectionViewCell.identifire, for: indexPath) as? MovieCastCollectionViewCell else { return UICollectionViewCell() }
        if let imageURL = presenter.getCastURL(for: indexPath.row) {
            cell.castImageView.kf.setImage(with: URL(string: imageURL))
        }
        if let name = presenter.getCastName(for: indexPath.row) {
            cell.castNameLabel.text = name
        }
        if let character = presenter.getCastCharacter(for: indexPath.row) {
            cell.castCharacterLabel.text = character
        }
        return cell
    }
}

extension MovieViewController: MovieViewProtocol {
    func success() {
        mainImage.kf.setImage(with: URL(string: presenter.getBackImageMovie()!))
        movieNameLabel.text = presenter.movie?.original_title
        movieInfoLabel.text = presenter.getYearMovie() + "\u{272F}" + presenter.getGanrMovie(for: 0) + "\u{272F}" + presenter.getRuntimeMovie()
        movieTextRating.text = presenter.getRatingTextMovie()
        movieStarRating.rating = presenter.getRatingStarMovie()
        movieOverview.text = presenter.movie?.overview
        movieCastCollectionView.reloadData()
    }

    func failure(error: Error) {
        
    }
}
