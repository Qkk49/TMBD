import UIKit
import Kingfisher
import Cosmos

final class SerialViewController: UIViewController {
    
    //MARK: - Property
    var presenter: SerialViewPresenterProtocol!
    
    var serialImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var serialNameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.numberOfLines = 3
        return nameLabel
    }()

    var serialYearLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 14)
        return infoLabel
    }()
    
    var serialGenerLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.font = .systemFont(ofSize: 14)
        return infoLabel
    }()

    var serialTextRating: UILabel = {
        var textRating = UILabel()
        textRating.font = .systemFont(ofSize: 20)
        textRating.textColor = .systemRed
        return textRating
    }()
    
    var serialStarRating: CosmosView = {
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
        stackView.addArrangedSubview(serialNameLabel)
        stackView.addArrangedSubview(serialYearLabel)
        stackView.addArrangedSubview(serialGenerLabel)
        stackView.addArrangedSubview(serialTextRating)
        stackView.addArrangedSubview(serialStarRating)
        return stackView
    }()
    
    var serialOverview: UILabel = {
        var overview = UILabel()
        overview.font = .systemFont(ofSize: 14)
        overview.numberOfLines = 0
        return overview
    }()
    
    lazy var serialCastCollectionView: UICollectionView = {
        let castView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        castView.register(SerialCastCollectionViewCell.self, forCellWithReuseIdentifier: SerialCastCollectionViewCell.identifire)
        castView.register(SerialCastHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SerialCastHeaderCell.identifire)
        castView.dataSource = self
        castView.delegate = self
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
        view.backgroundColor = .white
        view.addSubviews(serialImage, stackView, serialOverview, serialToWebButton, serialCastCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }

    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            serialImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            serialImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            serialImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            serialImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            serialOverview.topAnchor.constraint(equalTo: serialImage.bottomAnchor, constant: 16),
            serialOverview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            serialOverview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            serialToWebButton.topAnchor.constraint(equalTo: serialOverview.bottomAnchor, constant: 20),
            serialToWebButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            serialToWebButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.055),
            serialToWebButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            serialCastCollectionView.topAnchor.constraint(equalTo: serialToWebButton.bottomAnchor, constant: 10),
            serialCastCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            serialCastCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            serialCastCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func toWeb(sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://www.themoviedb.org/tv/" + String(presenter.popular!))! as URL)
    }
}

//MARK: - Collection DataSource
extension SerialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, presenter.casts?.cast.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = serialCastCollectionView.dequeueReusableCell(withReuseIdentifier: SerialCastCollectionViewCell.identifire, for: indexPath) as? SerialCastCollectionViewCell else { return UICollectionViewCell() }
        
        cell.castImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w185" + presenter.getCastTvURL(for: indexPath.row)))
        cell.castNameLabel.text = presenter.getCastTvName(for: indexPath.row)
        cell.castCharacterLabel.text = presenter.getCastTvCharacter(for: indexPath.row)
        
        return cell
    }
}

//MARK: - Collection Layout
extension SerialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3.5, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = serialCastCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SerialCastHeaderCell.identifire, for: indexPath) as? SerialCastHeaderCell else { return UICollectionReusableView() }
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 80.0)
    }
}

extension SerialViewController: SerialViewProtocol {
    func success() {
        serialImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w342" + presenter.getBackImageSerial()))
        serialNameLabel.text = presenter.serial?.original_name
        serialYearLabel.text = presenter.getYearSerial()
        serialGenerLabel.text = presenter.getGanrSerial(for: 0)
        serialTextRating.text = presenter.getRatingLabelSerial()
        serialStarRating.rating = presenter.getRatingCosmosSerial()
        serialOverview.text = presenter.serial?.overview
        serialCastCollectionView.reloadData()
    }

    func failure(error: Error) {
        print(error)
    }
}
