import Foundation
import Kingfisher


final class StatUserPageModel {
    let defaultNetworkClient = DefaultNetworkClient()

    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        print (userId)
        let request = Request(endpoint: URL(string: Config.baseUrl + "/users" + "/\(userId)"), httpMethod: .get)
        print (userId)
        defaultNetworkClient.send(request: request, type: User.self, onResponse: completion)
    }
}

