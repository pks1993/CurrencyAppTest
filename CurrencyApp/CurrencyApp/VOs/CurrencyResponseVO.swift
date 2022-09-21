//
//  CurrencyResponse.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import Foundation

// MARK: - CurrencyResponse
struct CurrencyResponseVO: Codable {
    let time: TimeVO?
    let disclaimer, chartName: String?
    let bpi: BpiVO?
    
    func convertToCurrencyResponseRO() -> CurrencyResponseRO {
        return CurrencyResponseRO(time: self.time?.convertToTimeRO(),
                                  disclaimer: self.disclaimer,
                                  chartName: self.chartName,
                                  bpi: self.bpi?.convertToBpiRO())
    }
}

// MARK: - Bpi
struct BpiVO: Codable {
    let usd, gbp, eur: CurrencyVO?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
    
    func convertToBpiRO() -> BpiRO {
        return BpiRO(usd: self.usd?.converttoCurrencyRO(),
                     gbp: self.gbp?.converttoCurrencyRO(),
                     eur: self.eur?.converttoCurrencyRO())
    }
}

// MARK: - Eur
struct CurrencyVO: Codable {
    let code, symbol, rate, description: String?
    let rateFloat: Double?

    enum CodingKeys: String, CodingKey {
        case code, symbol, rate
        case description = "description"
        case rateFloat = "rate_float"
    }
    
    func converttoCurrencyRO() -> CurrencyRO {
        return CurrencyRO(code: self.code,
                          symbol: self.symbol,
                          rate: self.rate,
                          description: self.description,
                          rateFloat: self.rateFloat ?? 0.0)
    }
}

// MARK: - Time
struct TimeVO: Codable {
    let updated: String?
    let updatedISO: String?
    let updateduk: String?
    
    func convertToTimeRO() -> TimeRO {
        return TimeRO(updated: self.updated,
                      updatedISO: self.updatedISO,
                      updateduk: self.updateduk)
    }
}

