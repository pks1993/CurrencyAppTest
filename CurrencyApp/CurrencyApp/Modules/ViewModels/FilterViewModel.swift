//
//  FilterViewModel.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import RxRelay

enum FilterType {
    case date
    case currency
}
struct FilterViewModel {
    let filterTypeBehaviorRelay = BehaviorRelay<FilterType>(value: .date)
}
