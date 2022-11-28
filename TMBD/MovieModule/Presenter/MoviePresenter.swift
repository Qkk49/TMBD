import Foundation

protocol MovieViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MovieViewPresenterProtocol: AnyObject {
    init(view: MovieViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, trend: Int?)
    var movie: Movie? { get set }
    var trend: Int? { get set }
    var casts: Casts? { get set }
    func getThisMovie(id: Int)
    func getThisCast(id: Int)
    func tap()
    func getBackImageMovie() -> String?
    func getYearMovie() -> String
    func getGanrMovie(for indexpath : Int) -> String
    func getRuntimeMovie() -> String
    func getRatingTextMovie() -> String
    func getRatingStarMovie() -> Double
    func getCastURL(for indexpath : Int) -> String?
    func getCastName(for indexpath : Int) -> String?
    func getCastCharacter(for indexpath : Int) -> String?
}

class MoviePresenter: MovieViewPresenterProtocol {
   
    //MARK: - Property
    weak var view: MovieViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var trend: Int?
    var movie: Movie?
    var casts: Casts?
    
    //MARK: - Init
    required init(view: MovieViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, trend: Int?) {
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
    
    //MARK: - Navigation root
    func tap() {
        router?.popToRoot()
    }
    
    //MARK: - Get model property
    func getBackImageMovie() -> String? {
        let url = movie?.backdrop_path
        if url == nil {
            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        } else {
            return "https://image.tmdb.org/t/p/original" + url!
        }
    }
    
    func getYearMovie() -> String {
        let releaseDate = movie?.release_date
        if releaseDate == nil {
            return "123"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dataDate = dateFormatter.date(from: releaseDate!)
            
            dateFormatter.dateFormat = "yyyy"
            let newStringDate = dateFormatter.string(from: dataDate!)
            return newStringDate
        }
    }
    
    func getGanrMovie(for indexpath : Int) -> String {
        if movie?.genres != nil {
            let count = movie?.genres.count
            if count == 1 {
                let firstGanr = movie?.genres[indexpath].name
                return firstGanr!
            } else {
                let secondGanr = (movie?.genres[indexpath].name)! + ", " + (movie?.genres[indexpath + 1].name)!
                return secondGanr
            }
        } else { return "123" }
    }
    
    func getRuntimeMovie() -> String {
        let mockTime = movie?.runtime
        if mockTime == nil {
            return "123"
        } else {
            let hour = mockTime! / 60 % 60
            let minute = mockTime! % 60
            return String(format: "\(hour) h \(minute) min")
        }
    }
    
    func getRatingTextMovie() -> String {
        let mockRating = movie?.vote_average
        if mockRating == nil {
            return "123"
        } else {
            let result = NSString(format:"%.1f", mockRating!)
            return String(describing: result)
        }
    }
    
    func getRatingStarMovie() -> Double {
        let mockRating = movie?.vote_average
        if mockRating == nil {
            return 123.0
        } else {
            let result = mockRating! / 2
            return result
        }
    }
    
    func getCastURL(for indexpath : Int) -> String? {
        let url = casts?.cast[indexpath].profile_path
        if url == nil {
            return "https://image.tmdb.org/t/p/original/cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        } else {
            return "https://image.tmdb.org/t/p/original" + url!
        }
    }
    
    func getCastName(for indexpath : Int) -> String? {
        return casts?.cast[indexpath].name
    }
    
    func getCastCharacter(for indexpath : Int) -> String? {
        return casts?.cast[indexpath].character
    }
}
