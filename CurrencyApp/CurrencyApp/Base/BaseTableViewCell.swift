//
//  BaseTableViewCell.swift
//  CurrencyApp
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import UIKit
import RxSwift
class BaseTableViewCell: UITableViewCell {

    var disposableBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        bindData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        disposableBag = DisposeBag()
        bindData()
    }
    
    func bindData() {
        
    }

}

