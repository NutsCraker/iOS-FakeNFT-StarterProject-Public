//
//  GetUserByIdRequest.swift
//  FakeNFT
//
//  Created by Anton Vikhlyaev on 31.07.2023.
//

import Foundation

struct GetUserByIdRequest: NetworkRequest {
    private let id: String
    var endpoint: URL? { URL(string: "\(Config.baseUrl)/users/\(id)") }
    
    init(id: String) {
        self.id = id
    }
}
