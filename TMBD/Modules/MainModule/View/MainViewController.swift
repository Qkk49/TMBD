import UIKit
import Kingfisher

final class MainViewController: UIViewController {
    
    //MARK: - Property
    var presenter: MainViewPresenterProtocol!
    
    var titleMovieCollectionLabel: UILabel = {
        let movieCollectionLabel = UILabel()
        movieCollectionLabel.text = "Trending Movie"
        movieCollectionLabel.font = .boldSystemFont(ofSize: 22)
        movieCollectionLabel.textColor = .white
        return movieCollectionLabel
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        let movieView = UICollectionView(frame: .zero, collectionViewLayout: createMovieLayout())
        movieView.register(MainMovieCollectionViewCell.self, forCellWithReuseIdentifier: MainMovieCollectionViewCell.identifire)
        movieView.backgroundColor = .clear
        movieView.delegate = self
        movieView.dataSource = self
        return movieView
    }()
    
    var titleSerialCollectionLabel: UILabel = {
        let serialCollectionLabel = UILabel()
        serialCollectionLabel.text = "Popular TV"
        serialCollectionLabel.font = .boldSystemFont(ofSize: 22)
        serialCollectionLabel.textColor = .white
        return serialCollectionLabel
    }()
    
    private lazy var serialCollectionView: UICollectionView = {
        let serialView = UICollectionView(frame: .zero, collectionViewLayout: createSerialLayout())
        serialView.register(MainSerialCollectionViewCell.self, forCellWithReuseIdentifier: MainSerialCollectionViewCell.identifire)
        serialView.backgroundColor = .clear
        serialView.delegate = self
        serialView.dataSource = self
        return serialView
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
    //MARK: - addView(delegate/view property)
    private func addViews() {
        view.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.43)
        view.addSubviews(titleMovieCollectionLabel, movieCollectionView, titleSerialCollectionLabel, serialCollectionView)
        
        self.title = "TMBD"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleMovieCollectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleMovieCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            movieCollectionView.topAnchor.constraint(equalTo: titleMovieCollectionLabel.bottomAnchor, constant: 8),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleSerialCollectionLabel.topAnchor.constraint(equalTo: movieCollectionView.bottomAnchor),
            titleSerialCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            serialCollectionView.topAnchor.constraint(equalTo: titleSerialCollectionLabel.bottomAnchor, constant: 8),
            serialCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            serialCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            serialCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
}

//MARK: - Collection DataSource, Delegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            
            cell.movieImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w185" + presenter.getMoviePhotoUrl(for: indexPath.row)!))
            cell.movieTitleLabel.text = presenter.getMovieTitle(for: indexPath.row)
            cell.movieDataLabel.text = presenter.getMovieData(for: indexPath.row)
            
            return cell
        } else {
            guard let cell = serialCollectionView.dequeueReusableCell(withReuseIdentifier: MainSerialCollectionViewCell.identifire, for: indexPath) as? MainSerialCollectionViewCell else { return UICollectionViewCell() }
            
            cell.serialImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w185" + presenter.getSerialPhotoUrl(for: indexPath.row)!))
            cell.serialTitleLabel.text = presenter.getSerialTitle(for: indexPath.row)
            cell.serialDataLabel.text = presenter.getSerialData(for: indexPath.row)
            
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
 
extension MainViewController {
    //MARK: - Create Layouts
    private func createMovieLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.8))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2.0 / 5.0),
            heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createSerialLayout() -> UICollectionViewCompositionalLayout {
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
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
