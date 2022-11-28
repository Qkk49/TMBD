import UIKit
import Kingfisher
import Cosmos

class SerialViewController: UIViewController {
    
    //MARK: - Property
    var presenter: SerialViewPresenterProtocol!
    
    var serialImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.72
        return imageView
    }()

    var serialNameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .white
        return nameLabel
    }()

    var serialInfoLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.textColor = .lightText
        return infoLabel
    }()

    lazy var serialBackButton: UIButton = {
        var backButton = UIButton()
        var imageButton = UIImage(named: "backArrow")
        backButton.setImage(imageButton, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return backButton
    }()

    var serialRatingView: UIView = {
        var ratingView = UIView()
        return ratingView
    }()

    var serialRatingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.font = .systemFont(ofSize: 20)
        ratingLabel.textColor = .systemYellow
        return ratingLabel
    }()
    
    var serialRatingCosmos: CosmosView = {
        var ratingCosmos = CosmosView()
        ratingCosmos.settings.fillMode = .precise
        ratingCosmos.settings.emptyColor = .lightText
        ratingCosmos.settings.filledBorderColor = .systemYellow
        ratingCosmos.settings.emptyBorderColor = .lightText
        ratingCosmos.settings.starSize = 20
        ratingCosmos.settings.starMargin = 5
        ratingCosmos.settings.filledColor = .systemYellow
        return ratingCosmos
    }()

    var serialOverviewLabel: UILabel = {
        var overviewLabel = UILabel()
        overviewLabel.font = .systemFont(ofSize: 16)
        overviewLabel.textColor = .lightText
        overviewLabel.numberOfLines = 5
        return overviewLabel
    }()

    var serialCastTitleLabel: UILabel = {
        var castTitleLabel = UILabel()
        castTitleLabel.text = "Cast"
        castTitleLabel.font = .boldSystemFont(ofSize: 20)
        castTitleLabel.textColor = .white
        return castTitleLabel
    }()
    
    var serialCastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let castView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        castView.register(SerialCastCollectionViewCell.self, forCellWithReuseIdentifier: SerialCastCollectionViewCell.identifire)
        castView.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.0)
        return castView
    }()

    lazy var serialToWebButton: UIButton = {
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
        presenter.getThisSerial(id: presenter.popular!)
        presenter.getThisCastTv(id: presenter.popular!)
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.45, green: 0.40, blue: 0.53, alpha: 0.43)
        serialRatingView.addSubviews(serialRatingLabel, serialRatingCosmos)
        view.addSubviews(serialImage, serialBackButton, serialNameLabel, serialInfoLabel, serialRatingView, serialOverviewLabel, serialCastTitleLabel, serialCastCollectionView, serialToWebButton)
        addConstraints()
        createLayout()
        serialCastCollectionView.dataSource = self
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
        serialCastCollectionView.collectionViewLayout = layout
    }

    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            serialImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            serialImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            serialImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            serialImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),

            serialBackButton.topAnchor.constraint(equalTo: serialImage.topAnchor),
            serialBackButton.heightAnchor.constraint(equalTo: serialImage.heightAnchor, multiplier: 0.15),
            serialBackButton.widthAnchor.constraint(equalTo: serialImage.widthAnchor, multiplier: 0.15),

            serialNameLabel.bottomAnchor.constraint(equalTo: serialInfoLabel.topAnchor, constant: -4),
            serialNameLabel.centerXAnchor.constraint(equalTo: serialImage.centerXAnchor),

            serialInfoLabel.bottomAnchor.constraint(equalTo: serialImage.bottomAnchor, constant: -8),
            serialInfoLabel.centerXAnchor.constraint(equalTo: serialImage.centerXAnchor),

            serialRatingView.topAnchor.constraint(equalTo: serialImage.bottomAnchor, constant: 18),
            serialRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            serialRatingLabel.leadingAnchor.constraint(equalTo: serialRatingView.leadingAnchor),
            serialRatingLabel.centerYAnchor.constraint(equalTo: serialRatingView.centerYAnchor),
            serialRatingLabel.trailingAnchor.constraint(equalTo: serialRatingCosmos.leadingAnchor, constant: -8),

            serialRatingCosmos.trailingAnchor.constraint(equalTo: serialRatingView.trailingAnchor),
            serialRatingCosmos.centerYAnchor.constraint(equalTo: serialRatingView.centerYAnchor),

            serialOverviewLabel.topAnchor.constraint(equalTo: serialRatingView.bottomAnchor, constant: 16),
            serialOverviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            serialOverviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            serialCastTitleLabel.topAnchor.constraint(equalTo: serialOverviewLabel.bottomAnchor, constant: 16),
            serialCastTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            serialCastTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            serialCastCollectionView.topAnchor.constraint(equalTo: serialCastTitleLabel.bottomAnchor),
            serialCastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            serialCastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            serialCastCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            serialToWebButton.topAnchor.constraint(equalTo: serialCastCollectionView.bottomAnchor),
            serialToWebButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            serialToWebButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            serialToWebButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func back(sender: UIButton) {
        presenter.tap()
    }

    @objc func toWeb(sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://www.themoviedb.org/tv/" + String(presenter.popular!))! as URL)
    }
}

//MARK: - Collection DataSource
extension SerialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(10, presenter.casts?.cast.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = serialCastCollectionView.dequeueReusableCell(withReuseIdentifier: SerialCastCollectionViewCell.identifire, for: indexPath) as? SerialCastCollectionViewCell else { return UICollectionViewCell() }
        if let imageURL = presenter.getCastTvURL(for: indexPath.row) {
            cell.castImageView.kf.setImage(with: URL(string: imageURL))
        }
        if let name = presenter.getCastTvName(for: indexPath.row) {
            cell.castNameLabel.text = name
        }
        if let character = presenter.getCastTvCharacter(for: indexPath.row) {
            cell.castCharacterLabel.text = character
        }
        return cell
    }
}

extension SerialViewController: SerialViewProtocol {
    func success() {
        serialImage.kf.setImage(with: URL(string: presenter.getBackImageSerial()!))
        serialNameLabel.text = presenter.serial?.original_name
        serialInfoLabel.text = presenter.getYearSerial() + "\u{272F}" + presenter.getGanrSerial(for: 0)
        serialRatingLabel.text = presenter.getRatingLabelSerial()
        serialRatingCosmos.rating = presenter.getRatingCosmosSerial()
        serialOverviewLabel.text = presenter.serial?.overview
        serialCastCollectionView.reloadData()
    }

    func failure(error: Error) {
        
    }
}
