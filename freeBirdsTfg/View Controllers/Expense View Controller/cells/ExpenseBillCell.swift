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
    
     @IBOutlet weak var icoVoew: UIView!
    
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var statBackgroundView: UIView!
    
   
    @IBOutlet weak var percentageView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var innerLeftView: UIView!
    
    @IBOutlet weak var icoImage: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    
    
    @IBOutlet weak var widthPercentageConstraint: NSLayoutConstraint!
    
   
    @IBOutlet weak var pricelabel: UILabel!
    
    
    var model : ModelExpense?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        statView.layer.cornerRadius = 10.0
        statBackgroundView.layer.cornerRadius = 10.0
        statBackgroundView.alpha = 0.5
        
        MainHelper.theStyle(view: icoVoew)
        MainHelper.theStyle(view: midView)
        MainHelper.theStyle(view: innerLeftView)
        MainHelper.theStyle(view: percentageView)
        MainHelper.circleView(view: innerLeftView)
        MainHelper.borderShadowRedonde(view: innerLeftView)
        MainHelper.circleView(view: icoImage)
        MainHelper.borderShadowRedonde(view: icoImage)
        percentageLabel.textColor = UIColor .black
    }

    func setupCell(model: ModelExpense){
        self.model = model
        icoImage.image = UIImage(named: model.ico!)
        titleNameLabel.text = model.name!
        pricelabel.text = "\(model.quantify!.rounded(toPlaces: 2))€"
        
        statView.backgroundColor = UIColor().colorFromHex(model.color!)
        statBackgroundView.backgroundColor = UIColor().colorFromHex(model.color!)
        
       
    }
    
    

    func animation(percentage:Int){
//        DispatchQueue.main.async { [weak self] in
          UIView.animate(withDuration: 3) {
                self.percentageLabel.text = "\(percentage)%"
                  let widtTotal = self.midView.frame.width
                let totalConstant =  Float (percentage) * Float(widtTotal) / 100
                self.widthPercentageConstraint.constant = CGFloat(totalConstant)
          }
//        }
       
    }
    
}
