//
//  ConfirmExpenseView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
protocol confirmProtocol: class{
    
    func confirm()
}

class ConfirmExpenseView: UIView {

    @IBOutlet var contentView: UIView!
    var delegate : confirmProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("ConfirmExpenseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        MainHelper.theStyle(view: contentView)
        
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        delegate?.confirm()
    }
    
    
}
