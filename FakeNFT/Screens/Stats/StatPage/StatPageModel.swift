import Foundation

final class StatPageModel {
  //  let networkClient = DefaultNetworkClient()
    let networkClient = CustomNetworkClient()

    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        print("users list")
        print(Config.baseUrl)
        print("/users")
        let request = Request(endpoint: URL(string: Config.baseUrl + "/users"), httpMethod: .get)
        print("users list")
        
        networkClient.send(request: request, type: [User].self, onResponse: completion)
    }
}
