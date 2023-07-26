//
//  Models&Structs.swift
//  FakeNFT
//
//  Created by Alexander Farizanov on 03.07.2023.
//

import Foundation
import Kingfisher

struct Nft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String

    func previewUrl() -> URL? {
        guard let previewUrl = images.first else { return nil }
        return URL(string: previewUrl)
    }
}

struct User: Codable {
    let avatar: String
    let name: String
    let description: String
    let website: String
    let nfts: [Int]
    let rating: String
    let id: String
}

struct Request: NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]?
    var httpMethod: HttpMethod
}

struct PaymentStatus: Codable {
    let success: Bool
    let id: String
    let orderId: String
}
struct Currency: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct Order: Codable {
    let nfts: [Int]
    let id: String
}

struct Cryptocurrency {
    let name: String
    let shortname: CryptoCoin
}

enum CryptoCoin: String {
    case BTC
    case APE
    case ADA
    case DOGE
    case ETH
    case SHIB
    case SOL
    case USDT
}

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

struct ProfilePut: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
}

enum SortAttribute {
    case name
    case nftCount
}
