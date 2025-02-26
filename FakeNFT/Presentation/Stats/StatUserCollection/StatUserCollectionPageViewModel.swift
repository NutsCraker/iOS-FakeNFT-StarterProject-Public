import Foundation

final class StatUserCollectionPageViewModel {

    private let model: StatUserCollectionPageModel

    var onChange: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    private(set) var nftsIds: [Int]?
    
    private(set) var nfts: [Nft] = [] { didSet { onChange?() }}

    init(model: StatUserCollectionPageModel, ids: [Int]? ) {
        self.model = model
        self.nftsIds = ids
    }

    func getUserNfts(showLoader: @escaping (_ active: Bool) -> Void ) {
        guard let ids = nftsIds, !ids.isEmpty else { return }
        showLoader(true)
        model.fetchNfts(ids: ids) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                case .failure(let error):
                    self.onError?(error) { [weak self] in
                        self?.getUserNfts(showLoader: showLoader)
                    }
                }
                showLoader(false)
            }
        }
    }
}
