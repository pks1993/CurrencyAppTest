//
//  UIButton + Extension.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import UIKit

extension UIButton {
    func setupButton(titleColor : UIColor , title : String) {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
}
