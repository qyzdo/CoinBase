//
//  CoinsService.swift
//  Exchanger
//
//  Created by Oskar Figiel on 03/11/2020.
//

import Foundation

// MARK: - TimeFrame for service
enum TimeFrame: String, CaseIterable {
    case hours = "24h"
    case week = "7d"
    case month = "30d"
    case year = "1y"
    case fiveYears = "5y"

}

enum CoinsService {
    case coins
    case coin(identifier: String, timeFrame: TimeFrame)
}

extension CoinsService: Service {

    var baseURL: String {
        return "https://api.coinranking.com"
    }

    var path: String {
        switch self {
        case .coins:
            return "/v1/public/coins"
        case .coin(let identifier, let timeFrame):
            return "/v1/public/coin/\(identifier)/history/\(timeFrame.rawValue)"
        }
    }

    var method: ServiceMethod {
        return .get
    }
}
