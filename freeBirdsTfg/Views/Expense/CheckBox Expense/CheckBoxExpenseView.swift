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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("CheckBoxExpenseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    
}
