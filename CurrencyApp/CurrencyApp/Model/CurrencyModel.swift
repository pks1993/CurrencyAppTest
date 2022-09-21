//
//  CurrencyModel.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import Foundation
import RxSwift

struct CurrencyModel {
    static let shared = CurrencyModel()
    
    func getCurrencyData() -> Observable<CurrencyResponseVO?> {
        let url = APIConfig.HomeVC.getCurrencyData.getUrlString()
        
        return ApiClient.shared.request(url: url).flatMap { responseData -> Observable<CurrencyResponseVO?> in
            if let data = responseData as? Data ,
               let response = data.decode(modelType: CurrencyResponseVO.self) {
                return Observable.just(response)
            }
            
            return Observable.just(nil)
        }
    }
}
