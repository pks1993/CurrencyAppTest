//
//  CurrencyDBVO.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation

struct CurrencyDBVO : Codable {
    var date : String?
    var bpiVo : BpiVO?
    
    init(date : String , bpiVo : BpiVO?) {
        self.date = date
        self.bpiVo = bpiVo
    }
    
    func convertToCurrencyDBRO() -> CurrencyDBRO {
        return CurrencyDBRO(date: self.date ?? "",
                            bpiRo: self.bpiVo?.convertToBpiRO())
    }
}
