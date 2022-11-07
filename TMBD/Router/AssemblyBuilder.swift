import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createMovieModule(trend: Int?, router: RouterProtocol) -> UIViewController
    func createSerialModule(popular: Int?, router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createMovieModule(trend: Int?, router: RouterProtocol) -> UIViewController {
        let view = MovieViewController()
        let nerworkService = NetworkService()
        let presenter = MoviePresenter(view: view, networkService: nerworkService, router: router, trend: trend)
        view.presenter = presenter
        return view
    }
    
    func createSerialModule(popular: Int?, router: RouterProtocol) -> UIViewController {
        let view = SerialViewController()
        let nerworkService = NetworkService()
//        let presenter = MoviePresenter(view: view, networkService: nerworkService, router: router, trend: trend)
//        view.presenter = presenter
        return view
    }
}
