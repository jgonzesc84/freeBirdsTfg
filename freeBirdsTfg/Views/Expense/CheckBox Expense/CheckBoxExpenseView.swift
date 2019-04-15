//
//  CheckBoxExpense.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class CheckBoxExpenseView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fixedCB: UIView!
    @IBOutlet weak var variableCB: UIView!
    var controller : CheckBoxExpenseController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("CheckBoxExpenseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller = CheckBoxExpenseController(view:self)
        configureActionView()
    }
    
    func configureActionView(){
        let gestureFixedPay = UITapGestureRecognizer(target: self, action:  #selector(self.selectFixed))
        self.fixedCB.addGestureRecognizer(gestureFixedPay)
        let gestureVariabledPay = UITapGestureRecognizer(target: self, action:  #selector(self.selectVariable))
        self.variableCB.addGestureRecognizer(gestureVariabledPay)
        
    }
    
    @objc func selectFixed(sender:UITapGestureRecognizer){
       
    }
    
   @objc func selectVariable(sender:UITapGestureRecognizer){
    
    }
    
  
    
}
