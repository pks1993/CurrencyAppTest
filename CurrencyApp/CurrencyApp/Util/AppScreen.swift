//
//  AppScreen.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import UIKit

struct AppScreen {
    static var shared  = AppScreen()
    var currentVC : UIViewController?
    
    enum HomeVC {
        case presentFilterVC
        
        func show() {
            switch self {
            case .presentFilterVC:
                AppScreen.shared.presentFilterVC()
            }
        }
    }
}
extension AppScreen {
    func presentFilterVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.delegate = currentVC as? FilterViewDelegate
        AppScreen.shared.currentVC?.present(vc, animated: true)
    }
}
