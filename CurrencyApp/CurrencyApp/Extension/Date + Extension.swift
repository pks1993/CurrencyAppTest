//
//  Date + Extension.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation

extension Date {
    func convertDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
