//
//  ModalCompleteHouse.swift
//  freeBirdsTfg
//
//  Created by Javier on 22/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ModalCompleteHouse: UIView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descritionTextView: UITextView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var acceptButton: Button!
    var controller : ModalCompleteHouseController?
    
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
    }
    
    func initView(){
        controller = ModalCompleteHouseController(modalCompleteHouse: self)
        MainHelper.theStyle(view:self)
    }
    
    
    
    
}
