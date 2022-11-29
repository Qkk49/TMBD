import Foundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceMainProtocol, router: RouterProtocol)
    func getMovies()
    func getSerials()
    func tapOnTheTrend(trend: Int?)
    func tapOnThePopular(popular: Int?)
    var movies: Trends? { get set }
    var serials: Populars? { get set }
    func getMoviePhotoUrl(for indexpath : Int) -> String?
    func getMovieTitle(for indexpath : Int) -> String?
    func getMovieData(for indexpath : Int) -> String?
    func getSerialPhotoUrl(for indexpath : Int) -> String?
    func getSerialTitle(for indexpath : Int) -> String?
    func getSerialData(for indexpath : Int) -> String?
}

final class MainPresenter: MainViewPresenterProtocol {
    //MARK: - Property
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceMainProtocol!
    var movies: Trends?
    var serials: Populars?
    
    //MARK: - Init
    required init(view: MainViewProtocol, networkService: NetworkServiceMainProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getMovies()
        getSerials()
    }
    
    //MARK: - Get Models
    func getMovies() {
        networkService.getMovies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func getSerials() {
        networkService.getSerials { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let serials):
                    self.serials = serials
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    //MARK: - Go to next Module
    func tapOnTheTrend(trend: Int?) {
        router?.showMovie(trend: trend)
    }
    
    func tapOnThePopular(popular: Int?) {
        router?.showSerial(popular: popular)
    }
    
    //MARK: - Get model property
    func getMoviePhotoUrl(for indexpath: Int) -> String? {
        guard let movieUrl = movies?.results[indexpath].poster_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return movieUrl
    }
    func getMovieTitle(for indexpath: Int) -> String? {
        guard let movieTitle = movies?.results[indexpath].original_title else {
            return "MissTitle"
        }
        return movieTitle
    }
    
    func getMovieData(for indexpath: Int) -> String? {
        guard let movieDate = movies?.results[indexpath].release_date else {
            return "Nov 1, 2000"
        }
        return mainDate(movieDate)
    }
    
    func getSerialPhotoUrl(for indexpath: Int) -> String? {
        guard let serialUrl = serials?.results[indexpath].poster_path else {
            return "cckcYc2v0yh1tc9QjRelptcOBko.jpg"
        }
        return serialUrl
    }
    
    func getSerialTitle(for indexpath: Int) -> String? {
        guard let serialTitle = serials?.results[indexpath].name else {
            return "MissTitle"
        }
        return serialTitle
    }
    
    func getSerialData(for indexpath: Int) -> String? {
        guard let serialDate = serials?.results[indexpath].first_air_date else {
            return "Nov 1, 2000"
        }
        return mainDate(serialDate)
    }
}
