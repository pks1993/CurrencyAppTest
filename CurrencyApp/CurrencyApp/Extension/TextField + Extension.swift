//
//  TextField + Extension.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import Foundation
import UIKit

extension UITextField {
    func setupTextField() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.textAlignment = .center
    }
}
