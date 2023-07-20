import Foundation 

final class CollectionDataProvider: CollectionDataProviderProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getOrder(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let getOrderRequest = GetOrderRequest()
        networkClient.send(request: getOrderRequest, type: OrderModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(with nftIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let putOrderRequest = PutOrderRequest(nftIds: nftIds)
        networkClient.send(request: putOrderRequest, type: OrderModel.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNFT(by id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let getNFTByIdRequest = GetNFTByIdRequest(id: id)
        networkClient.send(request: getNFTByIdRequest, type: NFTModel.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAuthor(by id: String, completion: @escaping (Result<AuthorModel, Error>) -> Void) {
        let getUserByIdRequest = GetUserByIdRequest(id: id)
        networkClient.send(request: getUserByIdRequest, type: AuthorModel.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFavorites(completion: @escaping (Result<FavoritesModel, Error>) -> Void) {
        let getFavoritesRequest = GetFavoritesRequest()
        networkClient.send(request: getFavoritesRequest, type: FavoritesModel.self) { result in
            switch result {
            case .success(let favoritesModel):
                completion(.success(favoritesModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateFavorites(with favoritesIDs: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let putFavoritesRequest = PutFavoritesRequest(likes: favoritesIDs)
        networkClient.send(request: putFavoritesRequest, type: FavoritesModel.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
