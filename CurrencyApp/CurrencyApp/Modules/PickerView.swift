//
//  PickerView.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import UIKit

protocol PickerViewDelegate{
    func didTapCancel()
    func didTapChoose(selectedDate : Date)
}
class PickerView: BaseView {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate = Date()
    var delegate : PickerViewDelegate?
    override func setupUI() {
        super.setupUI()
        
        btnCancel.setupButton(titleColor: UIColor.red, title: "Cancel")
        btnChoose.setupButton(titleColor: UIColor.darkGray, title: "Choose")
        
        datePicker.maximumDate = Date()
        
    }
    
    override func bindData() {
        super.bindData()
        
        btnCancel.rx.tap.bind{_ in
            self.delegate?.didTapCancel()
        }.disposed(by: disposableBag)
        
        btnChoose.rx.tap.bind{_ in
            self.selectedDate = self.datePicker.date
            self.delegate?.didTapChoose(selectedDate: self.selectedDate)
        }.disposed(by: disposableBag)
    }
}
