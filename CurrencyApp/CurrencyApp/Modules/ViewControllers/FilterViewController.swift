//
//  FilterViewController.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 21/09/2022.
//

import UIKit
import SnapKit
import RxSwift
protocol FilterViewDelegate {
    func didTapFilter(date : String , currencyType : CurrencyType , filterType : FilterType)
}
class FilterViewController: UIViewController {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    @IBOutlet weak var btnFilter: UIButton!
    
    var disposalBag = DisposeBag()
    
    var viewModel = FilterViewModel()
    var bgView = UIView(frame: CGRect.zero)
    var datePickerView = PickerView(frame: CGRect.zero)
    
    var selectedDate = ""
    var selectedCurrencyType : CurrencyType = .usd
    var filterType : FilterType?
    var delegate : FilterViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
       
        btnCalendar.setupButton(titleColor: UIColor.darkGray, title:"Choose Filter Date")
        btnFilter.setupButton(titleColor: UIColor.red, title: "Filter")
        
        currencySegment.setTitle(CurrencyType.usd.getCurrencyName(), forSegmentAt: 0)
        currencySegment.setTitle(CurrencyType.gbp.getCurrencyName(), forSegmentAt: 1)
        currencySegment.setTitle(CurrencyType.eur.getCurrencyName(), forSegmentAt: 2)
        
        self.showDatePicker(isShow: false)
        
    }
    
    func bindData() {
        btnClose.rx.tap.bind {_ in
            self.dismiss(animated: true)
        }.disposed(by: disposalBag)
        
        btnCalendar.rx.tap.bind {_ in
            self.filterType = .date
            self.showDatePicker(isShow: true)
        }.disposed(by:disposalBag)
        
        currencySegment.rx.selectedSegmentIndex.bind {
            self.btnCalendar.setupButton(titleColor: UIColor.darkGray, title:"Choose Filter Date")
            self.selectedDate = ""
            switch $0 {
            case 0 :
                self.selectedCurrencyType = .usd
            case 1 :
                self.selectedCurrencyType = .gbp
            case 2 :
                self.selectedCurrencyType = .eur
            default:
                break
            }
            self.filterType = .currency
        }.disposed(by: disposalBag)
        
        
        btnFilter.rx.tap.bind {_ in
            self.dismiss(animated: true)
            if let filterType = self.filterType {
                self.delegate?.didTapFilter(date: self.selectedDate, currencyType: self.selectedCurrencyType, filterType: filterType)
            }
            
        }.disposed(by: disposalBag)
    }
    
    func showDatePicker(isShow : Bool) {
        if isShow {
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.addSubview(bgView)
            bgView.translatesAutoresizingMaskIntoConstraints = false
            
            bgView.snp.makeConstraints { make in
                make.leading.equalTo(self.view)
                make.trailing.equalTo(self.view)
                make.bottom.equalTo(self.view)
                make.top.equalTo(self.view)
            }
            
            datePickerView.delegate = self
            view.addSubview(datePickerView)
            datePickerView.translatesAutoresizingMaskIntoConstraints = false
            
            datePickerView.snp.makeConstraints { make in
                make.leading.equalTo(self.view)
                make.trailing.equalTo(self.view)
                make.bottom.equalTo(self.view)
                make.height.equalTo(350)
            }
        }
        else {
            bgView.removeFromSuperview()
            datePickerView.removeFromSuperview()
        }
    }

}

extension FilterViewController : PickerViewDelegate {
    func didTapCancel() {
        self.showDatePicker(isShow: false)
    }
    func didTapChoose(selectedDate: Date) {
        self.selectedDate = selectedDate.convertDateFormat()
        self.showDatePicker(isShow: false)
        self.btnCalendar.setTitle(self.selectedDate, for: .normal)
    }
}
