//
//  QunatifyView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class QuantifyView: UIView, UITextFieldDelegate {

   
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantifyTextField: UITextField!
    @IBOutlet weak var bodyView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
       
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("QuantifyView", owner: self, options: nil)
        addSubview(contentView)
        quantifyTextField.delegate = self
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        MainHelper.theStyle(view: bodyView)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
   

    
}
