//
//  CoinsService.swift
//  Exchanger
//
//  Created by Oskar Figiel on 03/11/2020.
//

import Foundation

enum CoinsService {
    case coins
    case coin(identifier: String)
}

extension CoinsService: Service {
    var baseURL: String {
        return "https://api.coinranking.com"
    }

    var path: String {
        switch self {
        case .coins:
            return "/v1/public/coins"
        case .coin(let identifier):
            return "/v1/public/coin/\(identifier)/history/24h"
        }
    }

    var method: ServiceMethod {
        return .get
    }
}
