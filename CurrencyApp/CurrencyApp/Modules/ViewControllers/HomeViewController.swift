//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import UIKit
import RxSwift
class HomeViewController: UIViewController {
    
    var disposalBag = DisposeBag()
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var txtChangeAmt: UITextField!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var tblCurrencyRate: UITableView!
    @IBOutlet weak var currencySegment: UISegmentedControl!
    
    var response : CurrencyResponseVO?
    var buttonType : ButtonType = .fromCurrency
    
    var countDownTime = 60
    var timer : Timer?
    var filterType : FilterType = .date
    var responseArray = [CurrencyResponseVO]()
    var cellType : CurrencyType?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        bindData()
        viewModel.getCurrencyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppScreen.shared.currentVC = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func setupUI() {
        setupTableView()
        
        title = "Currency App"
        
        let filterBtn = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(self.filterAction))
        navigationItem.rightBarButtonItem = filterBtn
        
        txtChangeAmt.placeholder = "Enter amount for calculate"
        txtChangeAmt.setupTextField()
        
        currencySegment.setTitle(CurrencyType.usd.getCurrencyName(), forSegmentAt: 0)
        currencySegment.setTitle(CurrencyType.gbp.getCurrencyName(), forSegmentAt: 1)
        currencySegment.setTitle(CurrencyType.eur.getCurrencyName(), forSegmentAt: 2)
        
        lblAmount.textAlignment = .center
        lblAmount.text = ""
        lblAmount.font = .boldSystemFont(ofSize: 15.0)
        lblAmount.numberOfLines = 0
        
        txtChangeAmt.keyboardType = .numberPad
    }
    
    func bindData() {
        viewModel.currencyResponsePublishRelay.bind{
            self.response = $0
            self.tblCurrencyRate.reloadData()
        }.disposed(by: disposalBag)
        
        currencySegment.rx.selectedSegmentIndex.bind {
            self.lblAmount.text = ""
            self.txtChangeAmt.text = ""
            self.viewModel.selectedCurrencyBehaviorRelay.accept(self.viewModel.tblCells[$0])
        }.disposed(by: disposalBag)
        
        txtChangeAmt.rx.text.orEmpty.bind(to: self.viewModel.currencyAmtBehaviorRelay).disposed(by: disposalBag)
        
        viewModel.currencyAmtBehaviorRelay.bind{
            if !$0.isEmpty {
                self.calculateAmt(value: Double($0) ?? 0.0)
            }
            
        }.disposed(by: disposalBag)
        
        viewModel.currencyResponseListPublishRelay.bind {
            self.responseArray = $0 ?? []
            self.tblCurrencyRate.reloadData()
        }.disposed(by: disposalBag)
    }
    
    //MARK: - Calculate amout via input and selected currency
    func calculateAmt(value : Double) {
        let selectedCurrency = self.viewModel.selectedCurrencyBehaviorRelay.value
        var exchangeBTC = 0.0
        switch selectedCurrency {
        case .usd :
            exchangeBTC = value / (response?.bpi?.usd?.rateFloat ?? 0.0)
        case .gbp :
            exchangeBTC = value / (response?.bpi?.gbp?.rateFloat ?? 0.0)
        case .eur :
            exchangeBTC = value / (response?.bpi?.eur?.rateFloat ?? 0.0)
        }
        
        lblAmount.text = "\(value) \(selectedCurrency.getCurrencyName()) = \(String(format: "%.4f", exchangeBTC)) BTC"
        
    }
    
    func setupTableView() {
        tblCurrencyRate.register(UINib(nibName: String(describing: CurrencyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CurrencyTableViewCell.self))
        tblCurrencyRate.delegate = self
        tblCurrencyRate.dataSource = self
    }
    
    // MARK: - Count down timer for calling api after 1 minute
    @objc func timerFire() {
        if countDownTime > 0 {
            countDownTime -= 1
        }
        else {
            countDownTime = 60
            viewModel.getCurrencyData()
        }
    }
    
    @objc func filterAction() {
        AppScreen.HomeVC.presentFilterVC.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    
}

//MARK: - UITableViewDelegate , UITableDataSource
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch filterType {
        case .date:
            return 1
        case .currency:
            return responseArray.count
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterType {
        case .date:
            return viewModel.tblCells.count
        case .currency:
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyTableViewCell.self), for: indexPath) as! CurrencyTableViewCell
        
        var currencyVo : CurrencyVO?
        
        switch filterType {
        case .date:
            cellType = viewModel.tblCells[indexPath.row]
        default :
            break
        }
        
        switch cellType {
        case .usd :
            currencyVo = response?.bpi?.usd
        case .gbp :
            currencyVo = response?.bpi?.gbp
        case .eur :
            currencyVo = response?.bpi?.eur
        case .none:
            break
        }
        
        
        if let currencyVo = currencyVo {
            cell.setupCell(currencyVo: currencyVo)
        }
        return cell
    }
}

extension HomeViewController : FilterViewDelegate {
    func didTapFilter(date: String, currencyType: CurrencyType, filterType : FilterType) {
        self.cellType = currencyType
        self.filterType = filterType
        switch filterType {
        case .date:
            viewModel.getDBDataByDate(date: date)
        case .currency:
            viewModel.getDBDataByCurrency(currencyType: currencyType)
        }
        
    }
}

