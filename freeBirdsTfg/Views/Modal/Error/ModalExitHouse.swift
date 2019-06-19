//
//  ModalExitHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 20/06/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalExitHouse: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var accceptButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func awakeFromNib() {
        MainHelper.theStyle(view: mainView)
        mainView.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0
        warningLabel.text = "Seguro que quieres salir de la casa?"
    }
    
    
    @IBAction func accepAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
    }
}
