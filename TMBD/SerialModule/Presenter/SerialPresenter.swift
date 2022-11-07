import Foundation

protocol SerialViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol SerialViewPresenterProtocol: AnyObject {
    init(view: SerialViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, popular: Int?)
    func getThisSerial(id: Int)
//    func getThisCast(id: Int)
    var serial: Serial? { get set }
    var popular: Int? { get set }
//    var casts: Casts? { get set }
//    func tap()
//    func getBackImageMovie(_: Int) -> String?
//    func getYearMovie(_: Int) -> String
//    func getGanrMovie(for indexpath : Int) -> String
//    func getRuntimeMovie(_: Int) -> String
//    func getRatingTextMovie(_: Int) -> String
//    func getRatingStarMovie(_: Int) -> Double
//    func getCastURL(for indexpath : Int) -> String?
//    func getCastName(for indexpath : Int) -> String?
//    func getCastCharacter(for indexpath : Int) -> String?
}

class SerialPresenter: SerialViewPresenterProtocol {
   
    
    weak var view: SerialViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var popular: Int?
    var serial: Serial?
//    var casts: Casts?
    
    
    required init(view: SerialViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, popular: Int?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.popular = popular
    }
    
    func getThisSerial(id: Int) {
        networkService.getMovie(id: trend!) { [weak self] result in  /////////////++++
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    self.movie = movie
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
//    func getThisCast(id: Int) {
//        networkService.getCast(id: trend!) { [weak self] result in
//            guard let self = self else {return}
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let casts):
//                    self.casts = casts
//                    self.view?.success()
//                case .failure(let error):
//                    self.view?.failure(error: error)
//                }
//            }
//        }
//    }
//
//    func tap() {
//        router?.popToRoot()
//    }
//
//    func getBackImageMovie(_: Int) -> String? {
//        let url = movie?.backdrop_path
//        if url == nil {
//            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
//        } else {
//            return "https://image.tmdb.org/t/p/original" + url!
//        }
//    }
//
//    func getYearMovie(_: Int) -> String {
//        if let releaseDate = movie?.release_date {
//            let mockDict = releaseDate
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let dataDate = dateFormatter.date(from: mockDict)!
//
//            dateFormatter.dateFormat = "yyyy"
//            let newStringDate = dateFormatter.string(from: dataDate)
//            return newStringDate
//        } else { return "123" }
//    }
//
//    func getGanrMovie(for indexpath : Int) -> String {
//        if movie?.genres != nil {
//            let count = movie?.genres.count
//            if count == 1 {
//                let firstGanr = movie?.genres[indexpath].name
//                return firstGanr!
//            } else {
//                let secondGanr = (movie?.genres[indexpath].name)! + ", " + (movie?.genres[indexpath + 1].name)!
//                return secondGanr
//            }
//        } else { return "123" }
//    }
//
//    func getRuntimeMovie(_: Int) -> String {
//        if movie?.runtime != nil {
//            let mockTime = movie!.runtime
//            let hour = mockTime / 60 % 60
//            let minute = mockTime % 60
//            return String(format: "\(hour) h \(minute) min")
//        } else { return "123" }
//    }
//
//    func getRatingTextMovie(_: Int) -> String {
//        if movie?.vote_average != nil {
//            let mockRating = movie!.vote_average
//            let result = NSString(format:"%.1f", mockRating)
//            return String(describing: result)
//        } else { return "123" }
//    }
//
//    func getRatingStarMovie(_: Int) -> Double {
//        if movie?.vote_average != nil {
//            let mockRating = movie!.vote_average
//            let result = mockRating / 2
//            return result
//        } else { return 123.0 }
//    }
//
//    func getCastURL(for indexpath : Int) -> String? {
//        let url = casts?.cast[indexpath].profile_path
//        if url == nil {
//            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
//        } else {
//            return "https://image.tmdb.org/t/p/original" + url!
//        }
//    }
//
//    func getCastName(for indexpath : Int) -> String? {
//        return casts?.cast[indexpath].name
//    }
//
//    func getCastCharacter(for indexpath : Int) -> String? {
//        return casts?.cast[indexpath].character
//    }
}
