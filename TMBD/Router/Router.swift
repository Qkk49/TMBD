import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showMovie(trend: Int?)
    func showSerial(popular: Int?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func showMovie(trend: Int?) {
        if let navigationController = navigationController {
            guard let movieViewController = assemblyBuilder?.createMovieModule(trend: trend, router: self) else { return }
            navigationController.pushViewController(movieViewController, animated: false)
        }
    }
    
    func showSerial(popular: Int?) {
        if let navigationController = navigationController {
            guard let serialViewController = assemblyBuilder?.createSerialModule(popular: popular, router: self) else { return }
            navigationController.pushViewController(serialViewController, animated: false)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
}
