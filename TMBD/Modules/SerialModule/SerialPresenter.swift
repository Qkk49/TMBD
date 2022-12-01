import Foundation

protocol SerialViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol SerialViewPresenterProtocol: AnyObject {
    init(view: SerialViewProtocol, networkService: NetworkServiceDetailProtocol, router: RouterProtocol, popular: Int?)
    var serial: Serial? { get set }
    var popular: Int? { get set }
    var casts: Casts? { get set }
    func getThisSerial(id: Int)
    func getThisCastTv(id: Int)
    func getBackImageSerial() -> String
    func getYearSerial() -> String
    func getGanrSerial(for indexpath : Int) -> String
    func getRatingLabelSerial() -> String
    func getRatingCosmosSerial() -> Double
    func getCastTvURL(for indexpath : Int) -> String
    func getCastTvName(for indexpath : Int) -> String
    func getCastTvCharacter(for indexpath : Int) -> String
}

final class SerialPresenter: SerialViewPresenterProtocol {
    //MARK: - Property
    weak var view: SerialViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceDetailProtocol!
    var popular: Int?
    var serial: Serial?
    var casts: Casts?
    
    //MARK: - Init
    required init(view: SerialViewProtocol, networkService: NetworkServiceDetailProtocol, router: RouterProtocol, popular: Int?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.popular = popular
    }
    
    //MARK: - Get Models
    func getThisSerial(id: Int) {
        networkService.getSerial(id: popular!) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let serial):
                    self.serial = serial
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getThisCastTv(id: Int) {
        networkService.getCast(type: "tv/", id: popular!) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let casts):
                    self.casts = casts
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }

    //MARK: - Get model property
    func getBackImageSerial() -> String {
        guard let url = serial?.poster_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return url
    }

    func getYearSerial() -> String {
        guard let releaseDate = serial?.first_air_date else {
            return "2000"
        }
        return mainDate(releaseDate)
    }

    func getGanrSerial(for indexpath : Int) -> String {
        guard let geners = serial?.genres else {
            return "Triler"
        }
        if geners.count == 1 {
            return geners[indexpath].name
        } else {
            return geners[indexpath].name + ", " + geners[indexpath + 1].name
        }
    }

    func getRatingLabelSerial() -> String {
        guard let mockRating = serial?.vote_average else {
            return "5.0"
        }
        let result = NSString(format:"%.1f", mockRating)
        return String(describing: result)
    }

    func getRatingCosmosSerial() -> Double {
        guard let mockRating = serial?.vote_average else {
            return 2.5
        }
        let result = mockRating / 2
        return result
    }

    func getCastTvURL(for indexpath : Int) -> String {
        guard let url = casts?.cast[indexpath].profile_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return url
    }
    
    func getCastTvName(for indexpath : Int) -> String {
        guard let castName = casts?.cast[indexpath].name else {
            return "Bred Pit"
        }
        return castName
    }
    
    func getCastTvCharacter(for indexpath : Int) -> String {
        guard let castCharacter = casts?.cast[indexpath].character else {
            return "Bred Pit"
        }
        return castCharacter
    }
}
