//
//  APIConfig.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import Foundation

struct APIConfig {
    static let currencyUrl = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    enum HomeVC {
        case getCurrencyData
        
        func getUrlString() -> String {
            switch self {
            case .getCurrencyData:
                return APIConfig.currencyUrl
            }
        }
    }
}
