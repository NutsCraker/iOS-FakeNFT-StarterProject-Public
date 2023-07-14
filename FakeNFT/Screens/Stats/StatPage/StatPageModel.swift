import Foundation

final class StatPageModel {
   let networkClient = DefaultNetworkClient()

    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {

        let request = Request(endpoint: URL(string: Config.baseUrl + "/users"), httpMethod: .get)
        
        networkClient.send(request: request, type: [User].self, onResponse: completion)
    }
}
