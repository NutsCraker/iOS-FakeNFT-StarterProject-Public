import UIKit

final class ScreenFactory: ScreenFactoryProtocol {

    func makeProfileScreen() -> UIViewController {
        let presenter = ProfilePresenter()
        let vc = ProfileViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
    
    func makeCatalogScreen() -> UIViewController {
        let presenter = CatalogPresenter()
        let vc = CatalogViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
    
    func makeCartScreen() -> UIViewController {
        let presenter = CartPresenter()
        let vc = CartViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
    
    func makeStatsScreen() -> UIViewController {
        //let presenter = StatsPresenter()
       // let vc = StatsViewController(presenter: presenter)
       // presenter.view = vc
        return StatPageViewController()
        
        //let rootController = StatPageViewController()
            //pushViewController(rootController, animated: false)
    }
    
}
