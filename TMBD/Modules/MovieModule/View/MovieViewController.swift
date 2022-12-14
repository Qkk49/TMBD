import UIKit
import Kingfisher
import Cosmos

final class MovieViewController: UIViewController {
    
    //MARK: - Property
    var presenter: MovieViewPresenterProtocol!
    
    var mainImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var movieNameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.numberOfLines = 3
        return nameLabel
    }()
    
    var movieYearLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 14)
        return infoLabel
    }()
    
    var movieGenerLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 14)
        return infoLabel
    }()
    
    var movieRuntimeLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 14)
        return infoLabel
    }()
    
    var movieTextRating: UILabel = {
        var textRating = UILabel()
        textRating.font = .systemFont(ofSize: 20)
        textRating.textColor = .systemRed
        return textRating
    }()
    
    var movieStarRating: CosmosView = {
        var starRating = CosmosView()
        starRating.settings.fillMode = .precise
        starRating.settings.emptyColor = .gray
        starRating.settings.filledBorderColor = .black
        starRating.settings.emptyBorderColor = .black
        starRating.settings.starSize = 20
        starRating.settings.starMargin = 5
        starRating.settings.filledColor = .systemRed
        return starRating
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieYearLabel)
        stackView.addArrangedSubview(movieGenerLabel)
        stackView.addArrangedSubview(movieRuntimeLabel)
        stackView.addArrangedSubview(movieTextRating)
        stackView.addArrangedSubview(movieStarRating)
        return stackView
    }()
    
    var movieOverview: UILabel = {
        var overview = UILabel()
        overview.font = .systemFont(ofSize: 14)
        overview.numberOfLines = 0
        return overview
    }()
    
    lazy var movieCastCollectionView: UICollectionView = {
        let castView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        castView.register(MovieCastCollectionViewCell.self, forCellWithReuseIdentifier: MovieCastCollectionViewCell.identifire)
        castView.register(MovieCastHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCastHeaderCell.identifire)
        castView.dataSource = self
        castView.delegate = self
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
        view.backgroundColor = .white
        view.addSubviews(mainImage, stackView, movieOverview, movieToWebButton, movieCastCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mainImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            mainImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            movieOverview.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 16),
            movieOverview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            movieOverview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            movieToWebButton.topAnchor.constraint(equalTo: movieOverview.bottomAnchor, constant: 20),
            movieToWebButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            movieToWebButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            movieToWebButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            movieCastCollectionView.topAnchor.constraint(equalTo: movieToWebButton.bottomAnchor, constant: 10),
            movieCastCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            movieCastCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieCastCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func toWeb(sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://www.themoviedb.org/movie/" + String(presenter.trend!))! as URL)
    }
}

//MARK: - Collection DataSource
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, presenter.casts?.cast.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieCastCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCastCollectionViewCell.identifire, for: indexPath) as? MovieCastCollectionViewCell else { return UICollectionViewCell() }

        cell.castImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w185" + presenter.getCastURL(for: indexPath.row)))
        cell.castNameLabel.text = presenter.getCastName(for: indexPath.row)
        cell.castCharacterLabel.text = presenter.getCastCharacter(for: indexPath.row)
        
        return cell
    }
}

//MARK: - Collection Layout
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3.5, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = movieCastCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCastHeaderCell.identifire, for: indexPath) as? MovieCastHeaderCell else { return UICollectionReusableView() }
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 80.0)
    }
}

//MARK: - Setup View
extension MovieViewController: MovieViewProtocol {
    func success() {
        mainImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w342" + presenter.getBackImageMovie()))
        movieNameLabel.text = presenter.movie?.original_title
        movieYearLabel.text = presenter.getYearMovie()
        movieGenerLabel.text = presenter.getGanrMovie(for: 0)
        movieRuntimeLabel.text = presenter.getRuntimeMovie()
        movieTextRating.text = presenter.getRatingTextMovie()
        movieStarRating.rating = presenter.getRatingStarMovie()
        movieOverview.text = presenter.movie?.overview
        movieCastCollectionView.reloadData()
    }

    func failure(error: Error) {
        print(error)
    }
}
