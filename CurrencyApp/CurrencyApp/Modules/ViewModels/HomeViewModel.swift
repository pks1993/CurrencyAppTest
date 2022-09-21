//
//  HomeViewModel.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import Foundation
import RxRelay
import RxSwift

enum CurrencyType : String {
    case usd
    case gbp
    case eur
    
    func getCurrencyName() -> String {
        switch self {
        case .usd:
            return "USD"
        case .gbp:
            return "GBP"
        case .eur:
            return "EUR"
        }
    }
}

enum ButtonType {
    case fromCurrency
    case toCurrency
}

struct HomeViewModel {
    static let shared = HomeViewModel()
    var db = DBManager.sharedInstance
    let model = CurrencyModel()
    var disposableBag = DisposeBag()
    
    var tblCells : [CurrencyType] = [.usd , .gbp , .eur]
    
    let currencyResponsePublishRelay = PublishRelay<CurrencyResponseVO?>()
    let currencyResponseListPublishRelay = PublishRelay<[CurrencyResponseVO]?>()
    let errorObserable = PublishRelay<Error>()
    let currencyAmtBehaviorRelay = BehaviorRelay<String>(value: "")
    let selectedCurrencyBehaviorRelay = BehaviorRelay<CurrencyType>(value: .usd)
    
    func getCurrencyData() {
        model.getCurrencyData().subscribe {
            
            //MARK: - Saving response to Realm
            if let response = $0 {
                self.currencyResponsePublishRelay.accept(response)
                self.db.saveData(data: response.convertToCurrencyResponseRO(), value: CurrencyResponseRO.self) { error in
                    print(error)
                }
            }
        } onError: { error in
            self.errorObserable.accept(error)
        }.disposed(by: disposableBag)
    }
    
    
    func getDBDataByDate(date : String) {
        db.retrieveDataByKey(value: CurrencyResponseRO.self, key: "time.updatedISO", filterValue: date).subscribe {
            self.currencyResponsePublishRelay.accept($0.convertCurrencyResponseVO())
        } onError: { error in
            self.errorObserable.accept(error)
        }.disposed(by: disposableBag)
    }
    
    func getDBDataByCurrency(currencyType : CurrencyType) {
        db.retrieveCurrencyByKey(value: CurrencyResponseRO.self, key: "bpi.\(currencyType.rawValue).code", filterValue: currencyType.getCurrencyName()).subscribe {values in
            let array = values.compactMap {
                $0.convertCurrencyResponseVO()
            }
            self.currencyResponseListPublishRelay.accept(array)
        } onError: { error in
            self.errorObserable.accept(error)
        }.disposed(by: disposableBag)
    }
}
