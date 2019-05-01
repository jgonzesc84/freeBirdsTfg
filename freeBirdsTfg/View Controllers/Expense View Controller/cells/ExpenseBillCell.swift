//
//  ExpenseBillCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 01/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ExpenseBillCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var icoImage: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var widthPercentageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var percenatgeLabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    
    
    var model : ModelExpense?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func setupCell(model: ModelExpense, percentage:CGFloat){
        self.model = model
        icoImage.image = UIImage(named: model.ico!)
        titleNameLabel.text = model.name!
        pricelabel.text = model.quantify!
        statView.backgroundColor = UIColor().colorFromHex(model.color!)
         UIView.animate(withDuration: 1) {
        self.widthPercentageConstraint.constant = 100
        }
    }
    
    func animation(){
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 20) {
                self!.widthPercentageConstraint.constant = 100
            }
        }
       
    }
    
}
