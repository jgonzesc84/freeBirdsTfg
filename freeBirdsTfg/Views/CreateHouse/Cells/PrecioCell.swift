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

   
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var botSeparatorlaneView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var priceTextEdit: UITextField!
    @IBOutlet weak var okButton: UIButton!
    weak var delegate: PriceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        intiView()
       
    }

    func intiView(){
    
    self.selectionStyle = UITableViewCellSelectionStyle.none
    MainHelper.theStyle(view: borderView)
    priceTextEdit.placeholder = " PRECIO "
    priceTextEdit.keyboardType = UIKeyboardType.numberPad
    priceTextEdit.delegate = self
    acceptButton.layer.cornerRadius = acceptButton.frame.height / 2
        acceptButton.layer.borderWidth = 0
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
 /*   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let someting = textField.text
        let char = string
        return true
    }*/
    
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
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        if((priceTextEdit.text?.count)! > 0){
            priceTextEdit.resignFirstResponder()
        }
        
    }
}


protocol PriceDelegate: class {
    
    func passPrice( priceString: String?)
}

