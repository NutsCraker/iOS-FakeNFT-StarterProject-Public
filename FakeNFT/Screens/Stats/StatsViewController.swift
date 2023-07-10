
import UIKit

final class StatViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .asset(.white)
        navigationBar.tintColor = .asset(.black)

        let rootController = StatPageViewController()
        pushViewController(rootController, animated: false)
    }
}
