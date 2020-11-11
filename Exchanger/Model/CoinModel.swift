//
//  CoinModel.swift
//  Exchanger
//
//  Created by Oskar Figiel on 01/11/2020.
//

import Foundation

struct CoinModel: Codable {
    let status: String
    let data: DataClass
}

struct SingleCoinModel: Codable {
    let status: String
    let data: SingleDataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let base: Base
    let coins: [CoinElement]
}

struct SingleDataClass: Codable {
    let history: [History]
}

struct History: Codable {
    let price: String
    let timestamp: Int
}

// MARK: - Base
struct Base: Codable {
    let symbol, sign: String
}

// MARK: - CoinElement
struct CoinElement: Codable {
    let identifier: Int
    let uuid, slug, symbol, name: String
    let description: String?
    let iconUrl: String
    let iconType: String
    let price: String
    let change: Double
    let rank: Int
    let history: [String]
    let allTimeHigh: AllTimeHigh
    let penalty: Bool

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case uuid, slug, symbol, name, description, iconUrl, iconType, price, change, rank, history, penalty, allTimeHigh
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    let price: String
    let timestamp: Int
}
