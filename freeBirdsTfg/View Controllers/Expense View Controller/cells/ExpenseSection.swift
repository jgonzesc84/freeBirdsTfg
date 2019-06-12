//
//  ExpenseSection.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 30/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
protocol sectionExpenseProtocol {
    func goToEditExpense( _ model: ModelExpense)
    func deleteExpense( _ model: ModelExpense)
}

class ExpenseSection: UITableViewHeaderFooterView {
    
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
    
    @IBOutlet weak var editButton: UIButton!
    var percentage = 0
    
    @IBOutlet weak var widthPercentageConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var pricelabel: UILabel!
    
    var delegate : sectionExpenseProtocol?
    
    var model : ModelExpense?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        MainHelper.circleView(view: editButton)
        setupTap()
    }
    func resetCell(){
        self.widthPercentageConstraint.constant = 0
    }
    
    func setupCell(model: ModelExpense){
        self.model = model
        icoImage.image = UIImage(named: model.ico!)
        titleNameLabel.text = model.name!
        pricelabel.text = "\(model.quantify!.rounded(toPlaces: 2))€"
        statView.backgroundColor = UIColor().colorFromHex(model.color!)
        statBackgroundView.backgroundColor = UIColor().colorFromHex(model.color!)
        
    }
    
    override func layoutSubviews() {

    }
    
    
    
    func animation(percentage:Int){
        
        self.percentageLabel.text = "\(percentage)%"
        let widtTotal = self.midView.frame.width
        let totalConstant =  Float (percentage) * Float(widtTotal) / 100
        self.widthPercentageConstraint.constant = CGFloat(totalConstant)
        
        
    }
    
    
    func setupTap(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editActionExpense))
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func editActionExpense(sender: UITapGestureRecognizer? = nil) {
        
        if let modelSend = self.model{
            delegate?.goToEditExpense(modelSend)
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        if let modelSend = self.model{
             delegate?.deleteExpense(modelSend)
        }

    }
}
