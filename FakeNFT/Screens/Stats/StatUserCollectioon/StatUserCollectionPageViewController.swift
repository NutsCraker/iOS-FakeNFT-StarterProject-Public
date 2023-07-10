import UIKit
import ProgressHUD

final class StatUserCollectionPageViewController: UIViewController {
    private var viewModel: StatUserCollectionPageViewModel!
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(StatNFTCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onChange = { [weak self] in
            self?.change()
        }
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(title: "Ошибка при загрузке коллекции", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: { _ in
                retryAction()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        viewModel.getUserNfts { [weak self] active in
            self?.showLoader(isShow: active)
        }
        view.backgroundColor = .asset(.white)
        setupCollectionView()
    }
    
    init(viewModel: StatUserCollectionPageViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func change() {
        collectionView.reloadData()
    }
    
    // настройка коллекции
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .asset(.white)
        
        view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if viewModel.nftsIds == nil || viewModel.nftsIds?.isEmpty == true {
            let emptyLabel = UILabel()
            emptyLabel.text = "Коллекция пуста"
            emptyLabel.textColor = .asset(.black)
            emptyLabel.font = .bodyRegular
            emptyLabel.textAlignment = .center
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            collectionView.addSubview(emptyLabel)
            
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
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

extension StatUserCollectionPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nfts.count
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? StatNFTCell else {
            fatalError("Unable to dequeue StatNFTCell")
        }
        
        let nft = viewModel.nfts[indexPath.row]
        cell.configure(with: nft)
        return cell
    }
    
}

extension StatUserCollectionPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 16 - 16 - 16) / 3, height: 192)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }
}

