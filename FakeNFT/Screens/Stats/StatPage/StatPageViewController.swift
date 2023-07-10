import UIKit
import ProgressHUD

final class StatPageViewController: UIViewController {
    private var viewModel: StatPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.white)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let navigationController = UINavigationController(rootViewController: StatPageViewController())
        
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = menuButton
        let model = StatPageModel()
        viewModel = StatPageViewModel(model: model)
        viewModel.onChange = { [weak self] in
            self?.updateTable()
        }
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(title: "Ошибка при загрузке пользователей", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: { _ in
                retryAction()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        viewModel.getUsers(showLoader: showLoader)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset = .init(top: 0, left: 32, bottom: 0, right: 32)
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .asset(.white)
        return table
    }()
    
    private lazy var menuButton: UIBarButtonItem = {
        let menuButton = UIBarButtonItem(
            image: .asset(.sort),
            style: .plain,
            target: self,
            action: #selector(openMenu)
        )
        menuButton.tintColor = .asset(.black)
        return menuButton
    }()
    
    // добавление трекера
    @objc
    private func openMenu() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "По имени", style: .default, handler: { (_)in
            self.viewModel.setSortedByName()
        }))
        
        alert.addAction(UIAlertAction(title: "По количеству токенов", style: .default, handler: { (_)in
            self.viewModel.setSortedByCount()
        }))
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showLoader(isShow: Bool) {
        DispatchQueue.main.async {
            if isShow {
                self.view.isUserInteractionEnabled = false
                ProgressHUD.show()
            } else {
                self.view.isUserInteractionEnabled = true
                ProgressHUD.dismiss()
            }
        }
    }
}

// делегат
extension StatPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = viewModel.users[indexPath.row]
        
        let viewController = StatUserPageViewController(userId: user.id)
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// датасорс
extension StatPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let userCell = cell as? UserViewCell else {
            assertionFailure("Can't get cell for statisticsPage")
            return UITableViewCell()
        }
        
        let user = viewModel.users[indexPath.row]
        let cellViewModel = UserViewCellViewModel(user: user, cellIndex: indexPath.row)
        userCell.configure(with: cellViewModel)
        
        return userCell
    }
}
