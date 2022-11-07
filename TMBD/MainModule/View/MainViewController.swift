import UIKit
import Kingfisher

final class MainViewController: UIViewController {
    
    //MARK: - Property
    var presenter: MainViewPresenterProtocol!
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Qkk49"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textColor = .white
        return titleLabel
    }()
        
    var titleMovieCollectionLabel: UILabel = {
        let movieCollectionLabel = UILabel()
        movieCollectionLabel.text = "Popular movie"
        movieCollectionLabel.font = .boldSystemFont(ofSize: 18)
        movieCollectionLabel.textColor = .white
        return movieCollectionLabel
    }()
    
    private var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let movieView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        movieView.register(MainMovieCollectionViewCell.self, forCellWithReuseIdentifier: MainMovieCollectionViewCell.identifire)
        movieView.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.0)
        return movieView
    }()
    
    var titleSerialCollectionLabel: UILabel = {
        let serialCollectionLabel = UILabel()
        serialCollectionLabel.text = "TV Show"
        serialCollectionLabel.font = .boldSystemFont(ofSize: 18)
        serialCollectionLabel.textColor = .white
        return serialCollectionLabel
    }()
    
    private var serialCollectionView: UICollectionView = {
        let layoutSerial = UICollectionViewFlowLayout()
        let serialView = UICollectionView(frame: .zero, collectionViewLayout: layoutSerial)
        serialView.register(MainSerialCollectionViewCell.self, forCellWithReuseIdentifier: MainSerialCollectionViewCell.identifire)
        serialView.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.0)
        return serialView
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
        createMovieLayout()
        createSerialLayout()
    }
    
    //MARK: - addView(delegate/view property)
    private func addViews() {
        view.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.43)
        view.addSubviews(titleLabel, titleMovieCollectionLabel, movieCollectionView, titleSerialCollectionLabel, serialCollectionView)
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        serialCollectionView.delegate = self
        serialCollectionView.dataSource = self
    }
    
    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            titleMovieCollectionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            titleMovieCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            movieCollectionView.topAnchor.constraint(equalTo: titleMovieCollectionLabel.bottomAnchor, constant: 8),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            movieCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleSerialCollectionLabel.topAnchor.constraint(equalTo: movieCollectionView.bottomAnchor),
            titleSerialCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            serialCollectionView.topAnchor.constraint(equalTo: titleSerialCollectionLabel.bottomAnchor, constant: 8),
            serialCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            serialCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            serialCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    //MARK: - Create Layouts
    private func createMovieLayout() {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.8))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2.0 / 5.0),
            heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous

        let layout = UICollectionViewCompositionalLayout(section: section)
        movieCollectionView.collectionViewLayout = layout
    }
    
    private func createSerialLayout() {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.8))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous

        let layoutSerial = UICollectionViewCompositionalLayout(section: section)
        serialCollectionView.collectionViewLayout = layoutSerial
    }
}

//MARK: - Collection DataSource, Delegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.movieCollectionView {
            return presenter.movies?.results.count ?? 0
        } else {
            return presenter.serials?.results.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.movieCollectionView {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: MainMovieCollectionViewCell.identifire, for: indexPath) as? MainMovieCollectionViewCell else { return UICollectionViewCell() }
            if let imageURL = presenter.getMoviePhotoUrl(for: indexPath.row) {
                cell.movieImageView.kf.setImage(with: URL(string: imageURL))
            }
            if let title = presenter.getMovieTitle(for: indexPath.row) {
                cell.movieTitleLabel.text = title
            }
            if let data = presenter.getMovieData(for: indexPath.row) {
                cell.movieDataLabel.text = data
            }
            return cell
        } else {
            guard let cell = serialCollectionView.dequeueReusableCell(withReuseIdentifier: MainSerialCollectionViewCell.identifire, for: indexPath) as? MainSerialCollectionViewCell else { return UICollectionViewCell() }
            if let imageURL = presenter.getSerialPhotoUrl(for: indexPath.row) {
                cell.serialImageView.kf.setImage(with: URL(string: imageURL))
            }
            if let title = presenter.getSerialTitle(for: indexPath.row) {
                cell.serialTitleLabel.text = title
            }
            if let data = presenter.getSerialData(for: indexPath.row) {
                cell.serialDataLabel.text = data
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.movieCollectionView {
            let trend = presenter.movies?.results[indexPath.row].id
            presenter.tapOnTheTrend(trend: trend)
        } else {
            let popular = presenter.serials?.results[indexPath.row].id
            presenter.tapOnThePopular(popular: popular)
        }
    }
}

extension MainViewController: MainViewProtocol {
    func success() {
        movieCollectionView.reloadData()
        serialCollectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
 
