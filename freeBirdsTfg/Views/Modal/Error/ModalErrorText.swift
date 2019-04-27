//
//  ModalErrorText.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 27/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalErrorText: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labeText: UILabel!
   
    override func awakeFromNib() {
        MainHelper.theStyle(view: mainView)
        mainView.layer.cornerRadius = 10.0
        self.layer.cornerRadius = 10.0
    }
    
    func setText(text : String){
        labeText.text = text
    }

}
