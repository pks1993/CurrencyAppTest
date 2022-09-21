//
//  CurrencyDBRO.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import RealmSwift

@objcMembers final class CurrencyResponseRO : Object {
    dynamic var  time: TimeRO?
    dynamic var disclaimer, chartName: String?
    dynamic var bpi: BpiRO?
    
    convenience init(time : TimeRO? , disclaimer : String? , chartName : String? , bpi : BpiRO?) {
        self.init()
        self.time = time
        self.disclaimer = disclaimer
        self.chartName = chartName
        self.bpi = bpi
    }
    
    func convertCurrencyResponseVO () -> CurrencyResponseVO {
        return CurrencyResponseVO(time: self.time?.convertToTimeVO(),
                                  disclaimer: self.disclaimer,
                                  chartName: self.chartName,
                                  bpi: self.bpi?.convertToBpiVO())
    }
}

@objcMembers final class CurrencyDBRO : Object {
    @objc dynamic var date: String?
    @objc dynamic var bpiRo : BpiRO?
    
    convenience init(date : String , bpiRo : BpiRO?) {
        self.init()
        self.date = date
        self.bpiRo = bpiRo
    }
    
    func converToCurrencyDBVO() -> CurrencyDBVO {
        return CurrencyDBVO(date: self.date ?? "",
                            bpiVo: self.bpiRo?.convertToBpiVO())
    }
    
}

@objcMembers final class BpiRO : Object {
    dynamic var usd, gbp, eur: CurrencyRO?
    
    convenience init(usd : CurrencyRO? , gbp : CurrencyRO? , eur : CurrencyRO?) {
        self.init()
        self.usd = usd
        self.gbp = gbp
        self.eur = eur
    }
    
    func convertToBpiVO() -> BpiVO {
        return BpiVO(usd: self.usd?.converttoCurrencyVO(),
                     gbp: self.gbp?.converttoCurrencyVO(),
                     eur: self.eur?.converttoCurrencyVO())
    }
}

@objcMembers final class CurrencyRO : Object {
    dynamic var code, symbol, rate, desc : String?
    dynamic var rateFloat: Double = 0.0
    
    convenience init(code : String? , symbol : String?, rate : String? , description : String? , rateFloat : Double) {
        self.init()
        self.code = code
        self.symbol = symbol
        self.rate = rate
        self.desc = description
        self.rateFloat = rateFloat
    }
    
    func converttoCurrencyVO() -> CurrencyVO {
        return CurrencyVO(code: self.code,
                          symbol: self.symbol,
                          rate: self.rate,
                          description: self.desc,
                          rateFloat: self.rateFloat)
    }
}

@objcMembers final class TimeRO : Object {
    dynamic var updated: String?
    dynamic var updatedISO: String?
    dynamic var updateduk: String?
    
    convenience init(updated : String? , updatedISO : String? , updateduk : String?) {
        self.init()
        self.updated = updated
        self.updatedISO = updatedISO
        self.updateduk = updateduk
    }
    
    func convertToTimeVO() -> TimeVO {
        return TimeVO(updated: self.updated,
                      updatedISO: self.updatedISO,
                      updateduk: self.updateduk)
    }
}

