import Foundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getMovies()
    func getSerials()
    func tapOnTheTrend(trend: Int?)
    var movies: Trends? { get set }
    var serials: Populars? { get set }
    func getMoviePhotoUrl(for indexpath : Int) -> String?
    func getMovieTitle(for indexpath : Int) -> String?
    func getMovieData(for indexpath : Int) -> String?
    func getSerialPhotoUrl(for indexpath : Int) -> String?
    func getSerialTitle(for indexpath : Int) -> String?
    func getSerialData(for indexpath : Int) -> String?
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var movies: Trends?
    var serials: Populars?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getMovies()
        getSerials()
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
    
    func tapOnTheTrend(trend: Int?) {
        router?.showMovie(trend: trend)
    }
    
    func getMoviePhotoUrl(for indexpath : Int) -> String? {
        return "https://image.tmdb.org/t/p/original" + (movies?.results[indexpath].poster_path)!
    }
    func getMovieTitle(for indexpath : Int) -> String? {
        return movies?.results[indexpath].original_title
    }
    
    func getMovieData(for indexpath : Int) -> String? {
        let mockDict = movies?.results[indexpath].release_date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataDate = dateFormatter.date(from: mockDict!)!

        dateFormatter.dateFormat = "MMM d, yyyy"
        let newStringDate = dateFormatter.string(from: dataDate)
        return newStringDate
    }
    
    func getSerialPhotoUrl(for indexpath : Int) -> String? {
        return "https://image.tmdb.org/t/p/original" + (serials?.results[indexpath].poster_path)!
    }
    func getSerialTitle(for indexpath : Int) -> String? {
        return serials?.results[indexpath].name
    }
    
    func getSerialData(for indexpath : Int) -> String? {
        let mockDict = serials?.results[indexpath].first_air_date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dataDate = dateFormatter.date(from: mockDict!)!

        dateFormatter.dateFormat = "MMM d, yyyy"
        let newStringDate = dateFormatter.string(from: dataDate)
        return newStringDate
    }
}
