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
  
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var paiedLabel: UILabel!
    @IBOutlet weak var quantifyView: UIView!
    @IBOutlet weak var quantifyLabel: UILabel!
    
   
    @IBOutlet weak var columnView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    var model : ModelExpense?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
         initView()
    }
    func initView(){
        MainHelper.circleView(view: circleView)
        MainHelper.theStyle(view: mainView)
       
        MainHelper.circleView(view: quantifyView)
        MainHelper.borderShadowRedondNotRadius(view: quantifyView)
      
        MainHelper.giveMeStyle(label: quantifyLabel)
        MainHelper.giveMeStyle(label: paiedLabel)
        
        MainHelper.giveMeStyle(label: nameLabel)
        
    }
    func resetCell(){

    }
    func setupCell(model: ModelPayment,color: String){
       
        let user = HouseManager.sharedInstance.house!.user!.first(where:{$0.idUser == model.idUser})
        columnView.backgroundColor = UIColor().colorFromHex(color)
        circleView.backgroundColor = UIColor().colorFromHex(color)
        nameLabel.text = user?.alias
        // "\(model.quantify!.rounded(toPlaces: 2))€"
        quantifyLabel.text = String(model.quantify.rounded(toPlaces: 2))
        paiedLabel.text = "\(model.payed.rounded(toPlaces: 2)) de"
        quantifyLabel.textColor = UIColor().colorFromHex(color)
        
        
    }

    
}
