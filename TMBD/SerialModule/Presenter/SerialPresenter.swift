import Foundation

protocol SerialViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol SerialViewPresenterProtocol: AnyObject {
    init(view: SerialViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, popular: Int?)
    var serial: Serial? { get set }
    var popular: Int? { get set }
    var casts: Casts? { get set }
    func getThisSerial(id: Int)
    func getThisCastTv(id: Int)
    func tap()
    func getBackImageSerial() -> String?
    func getYearSerial() -> String
    func getGanrSerial(for indexpath : Int) -> String
    func getRatingLabelSerial() -> String
    func getRatingCosmosSerial() -> Double
    func getCastTvURL(for indexpath : Int) -> String?
    func getCastTvName(for indexpath : Int) -> String?
    func getCastTvCharacter(for indexpath : Int) -> String?
}

class SerialPresenter: SerialViewPresenterProtocol {
    //MARK: - Property
    weak var view: SerialViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var popular: Int?
    var serial: Serial?
    var casts: Casts?
    
    //MARK: - Init
    required init(view: SerialViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, popular: Int?) {
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

    //MARK: - Navigation root
    func tap() {
        router?.popToRoot()
    }

    //MARK: - Get model property
    func getBackImageSerial() -> String? {
        let url = serial?.backdrop_path
        if url == nil {
            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        } else {
            return "https://image.tmdb.org/t/p/original" + url!
        }
    }

    func getYearSerial() -> String {
        let mockDict = serial?.first_air_date
        if mockDict == nil {
            return "123"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dataDate = dateFormatter.date(from: mockDict!)

            dateFormatter.dateFormat = "yyyy"
            let newStringDate = dateFormatter.string(from: dataDate!)
            return newStringDate
        }
    }

    func getGanrSerial(for indexpath : Int) -> String {
        if serial?.genres != nil {
            let count = serial?.genres.count
            if count == 1 {
                let firstGanr = serial?.genres[indexpath].name
                return firstGanr!
            } else {
                let secondGanr = (serial?.genres[indexpath].name)! + ", " + (serial?.genres[indexpath + 1].name)!
                return secondGanr
            }
        } else { return "123" }
    }

    func getRatingLabelSerial() -> String {
        let mockRating = serial?.vote_average
        if mockRating == nil {
            return "123"
        } else {
            let result = NSString(format:"%.1f", mockRating!)
            return String(describing: result)
        }
    }

    func getRatingCosmosSerial() -> Double {
        let mockRating = serial?.vote_average
        if mockRating == nil {
            return 123.0
        } else {
            let result = mockRating! / 2
            return result
        }
    }

    func getCastTvURL(for indexpath : Int) -> String? {
        let url = casts?.cast[indexpath].profile_path
        if url == nil {
            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        } else {
            return "https://image.tmdb.org/t/p/original" + url!
        }
    }

    func getCastTvName(for indexpath : Int) -> String? {
        return casts?.cast[indexpath].name
    }

    func getCastTvCharacter(for indexpath : Int) -> String? {
        return casts?.cast[indexpath].character
    }
}
