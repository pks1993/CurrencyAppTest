//
//  CurrencyTableViewCell.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import UIKit

class CurrencyTableViewCell: BaseTableViewCell {
    @IBOutlet weak var lblCurrencyCode: UILabel!
    @IBOutlet weak var lblCurrencyName: UILabel!
    @IBOutlet weak var lblCurrencySymbol: UILabel!
    @IBOutlet weak var lblCurrencyValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupUI() {
        super.setupUI()
        
        lblCurrencyCode.font = .boldSystemFont(ofSize: 15.0)
        
        lblCurrencyName.font = .boldSystemFont(ofSize: 15.0)
        
        lblCurrencySymbol.font = .systemFont(ofSize: 15.0)
        
        lblCurrencyValue.font = .systemFont(ofSize: 15.0)
    }
    
    func setupCell(currencyVo : CurrencyVO) {
        lblCurrencyCode.text = currencyVo.code ?? ""
        lblCurrencyName.text = currencyVo.description ?? ""
        lblCurrencySymbol.text = currencyVo.symbol?.htmlDecoded ?? ""
        lblCurrencyValue.text = currencyVo.rate ?? ""
    }
    
}
