import Foundation
import UIKit

protocol CatalogueViewModelDelegate: AnyObject {
    func presentSortActionSheet(_ actionSheet: UIAlertController)
    func didSelectSortType(_ sortType: SortType)
}

final class CatalogueViewModel {
    
    // MARK: - Properties

    @Observable private(set) var collections: [NFTCollection] = []
    @Observable private(set) var errorDescription: String = ""
    private let provider: CatalogueProviderProtocol
    private let setupManager = SetupManager.shared
    weak var delegate: CatalogueViewModelDelegate?
    private var catalogueViewModel: CatalogueViewModel?
    
    private var sort: SortType? {
        didSet {
            guard let sort = sort else { return }
            applySort(by: sort)
            setupManager.sortCollectionsType = sort.rawValue
        }
    }
    
    // MARK: - Initialization
    
    init(provider: CatalogueProviderProtocol) {
        self.provider = provider
    }
    
    // MARK: - Functions
    
    private func setFilterByCount() {
        collections.sort(by: { $0.nfts.count > $1.nfts.count })
    }
    
    private func setFilterByName() {
        collections.sort(by: { $0.name > $1.name })
    }
    
    func setSortType(sortType: SortType) {
        self.sort = sortType
    }
    
    private func applySort(by value: SortType) {
        switch value {
        case .sortByCount:
            setFilterByCount()
        case .sortByName:
            setFilterByName()
        }
    }
    
    @objc
    internal func sortCollections() {
        let actionSheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByName = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectSortType(.sortByName)
        }
        
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didSelectSortType(.sortByCount)
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        
        actionSheet.addAction(sortByName)
        actionSheet.addAction(sortByCount)
        actionSheet.addAction(cancel)
        
        delegate?.presentSortActionSheet(actionSheet)
    }
    
    func getCollections() {
        provider.getCollections { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.collections = collections
                    
                    if let sortType = self.setupManager.sortCollectionsType {
                        self.setSortType(sortType: SortType.getTypeByString(stringType: sortType))
                    }
                case .failure(let error):
                    self.collections.removeAll()
                    self.errorDescription = error.localizedDescription
                }
            }
        }
    }
}