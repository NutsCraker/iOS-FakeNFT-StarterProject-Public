//
//  StatUserPage.swift
//  FakeNFT
//
//  Created by Alexander Farizanov on 03.07.2023.
//
import Foundation
import Kingfisher


final class StatUserPageModel {
    let defaultNetworkClient = DefaultNetworkClient()

    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = Request(endpoint: URL(string: Config.baseUrl + "/users" + "/\(userId)"), httpMethod: .get)
        defaultNetworkClient.send(request: request, type: User.self, onResponse: completion)
    }
}
