import Foundation

final class StatPageModel {
    let defaultNetworkClient = DefaultNetworkClient()

    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        print("users list")
        print(Config.baseUrl)
        print("/users")
        let request = Request(endpoint: URL(string: Config.baseUrl + "/users"), httpMethod: .get)
        print("users list")
        defaultNetworkClient.send(request: request, type: [User].self, onResponse: completion)
    }
}
