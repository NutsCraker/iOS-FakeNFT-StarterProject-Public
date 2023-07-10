import Foundation

final class StatUserCollectionPageModel {
    let defaultNetworkClient = DefaultNetworkClient()

    func fetchNfts(ids: [Int], completion: @escaping (Result<[Nft], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var resultNfts: [Nft] = []

        for id in ids {
            dispatchGroup.enter()

            let request = Request(endpoint: URL(string: Config.baseUrl + "/nft" + "/\(id)"), httpMethod: .get)
            defaultNetworkClient.send(request: request, type: Nft.self) { result in
                switch result {
                case .success(let nft):
                    resultNfts.append(nft)
                case .failure(let error):
                    print("Error: \(error)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(resultNfts))
        }
    }
}
