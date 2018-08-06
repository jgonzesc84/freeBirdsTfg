//
//  PrecioCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 5/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Lottie
import Material

class PrecioCell: UITableViewCell , TextFieldDelegate {

   
    @IBOutlet weak var priceTextEdit: UITextField!
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: PriceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        intiView()
       
    }

    func intiView(){
    
    self.selectionStyle = UITableViewCellSelectionStyle.none
    priceTextEdit.font = UIFont.AppFont.middleFont.middlWord
    priceTextEdit.textColor = UIColor.AppColor.Gray.greyApp
    priceTextEdit.layer.borderColor = UIColor.AppColor.Green.mindApp .cgColor
    priceTextEdit.layer.borderWidth = 3.0
    priceTextEdit.placeholder = " PRECIO "
        
    priceTextEdit.keyboardType = UIKeyboardType.numberPad
    priceTextEdit.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
       
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let price : String = textField.text!
        if (price.count > 0){
             delegate?.passPrice(priceString: price)
              self.endEditing(true)
        }
       
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let someting = textField.text
        let char = string
        return true
    }
    
    /*func animationSetup(){
        let animationView = LOTAnimationView(name: "checkAnimation")
        let frame = okButton.frame
        animationView.contentMode = UIViewContentMode.scaleAspectFill
        animationView.frame = CGRect(x:0, y: 0, width: frame.size.width, height: frame.size.height )
        okButton.addSubview(animationView)
        okButton.sendSubview(toBack:animationView )
        animationView.backgroundColor = UIColor .white
        animationView.play()
        animationView.loopAnimation = true
    }*/
    
}


protocol PriceDelegate: class {
    
    func passPrice( priceString: String?)
}

