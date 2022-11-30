import Foundation

protocol MovieViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MovieViewPresenterProtocol: AnyObject {
    init(view: MovieViewProtocol, networkService: NetworkServiceDetailProtocol, router: RouterProtocol, trend: Int?)
    var movie: Movie? { get set }
    var trend: Int? { get set }
    var casts: Casts? { get set }
    func getThisMovie(id: Int)
    func getThisCast(id: Int)
    func getBackImageMovie() -> String
    func getYearMovie() -> String
    func getGanrMovie(for indexpath : Int) -> String
    func getRuntimeMovie() -> String
    func getRatingTextMovie() -> String
    func getRatingStarMovie() -> Double
    func getCastURL(for indexpath : Int) -> String
    func getCastName(for indexpath : Int) -> String
    func getCastCharacter(for indexpath : Int) -> String
}

class MoviePresenter: MovieViewPresenterProtocol {
   
    //MARK: - Property
    weak var view: MovieViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceDetailProtocol!
    var trend: Int?
    var movie: Movie?
    var casts: Casts?
    
    //MARK: - Init
    required init(view: MovieViewProtocol, networkService: NetworkServiceDetailProtocol, router: RouterProtocol, trend: Int?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.trend = trend
    }
    
    //MARK: - Get Models
    func getThisMovie(id: Int) {
        networkService.getMovie(id: trend!) { [weak self] result in
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
    
    func getThisCast(id: Int) {
        networkService.getCast(type: "movie/", id: trend!) { [weak self] result in
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
    func getBackImageMovie() -> String {
        guard let url = movie?.poster_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return url
    }
    
    func getYearMovie() -> String {
        guard let releaseDate = movie?.release_date else {
            return "2000"
        }
        return mainDate(releaseDate)
    }
    
    func getGanrMovie(for indexpath : Int) -> String {
        guard let geners = movie?.genres else {
            return "Triler"
        }
        if geners.count == 1 {
            return geners[indexpath].name
        } else {
            return geners[indexpath].name + ", " + geners[indexpath + 1].name
        }
    }
    
    func getRuntimeMovie() -> String {
        guard let mockTime = movie?.runtime else {
            return "1 h 30 min"
        }
        return mainTime(mockTime)
    }
    
    func getRatingTextMovie() -> String {
        guard let mockRating = movie?.vote_average else {
            return "5.0"
        }
        let result = NSString(format:"%.1f", mockRating)
        return String(describing: result)
    }
    
    func getRatingStarMovie() -> Double {
        guard let mockRating = movie?.vote_average else {
            return 2.5
        }
        let result = mockRating / 2
        return result
    }
    
    func getCastURL(for indexpath : Int) -> String {
        guard let url = casts?.cast[indexpath].profile_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return url
    }
    
    func getCastName(for indexpath : Int) -> String {
        guard let castName = casts?.cast[indexpath].name else {
            return "Bred Pit"
        }
        return castName
    }
    
    func getCastCharacter(for indexpath : Int) -> String {
        guard let castCharacter = casts?.cast[indexpath].character else {
            return "Bred Pit"
        }
        return castCharacter
    }
}
