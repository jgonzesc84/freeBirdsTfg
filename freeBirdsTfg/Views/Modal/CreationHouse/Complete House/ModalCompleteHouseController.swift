//
//  ModalCompleteHouseController.swift
//  freeBirdsTfg
//
//  Created by Javier on 22/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class ModalCompleteHouseController{
    
    var modal : ModalCompleteHouse?
    var heightMax : CGFloat!
    
    init(modalCompleteHouse: ModalCompleteHouse!){
       modal = modalCompleteHouse
       heightMax = 0.0
    }
    
    func autoSizeTextView(textView: UITextView){
      let text = textView.text
        let limitHeight = (modal?.frame.size.height)! * 0.7
        if(text!.count > 0 ){
            enableAcceptButton()
            let fixedWidht = textView.frame.size.width
            let newSize = textView.sizeThatFits(CGSize(width:fixedWidht, height:CGFloat(MAXFLOAT)))
            var newFrame = textView.frame
            newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidht))), height: newSize.height)
            if( heightMax < limitHeight){
                textView.isScrollEnabled = false
                textView.frame = newFrame
                heightMax = newSize.height
                modal?.heightDescriptionConstraint.constant = CGFloat(heightMax)
            }else{
                textView.isScrollEnabled = true
                heightMax = newSize.height
            }
            
            
        }else{
            disableAcceptButton()
        }
        
    }
    
    func allowmaxCharacter(textView: UITextView, text: String ,range: NSRange) -> Bool{
        let maxCharacters = textView.text.count + (text.count - range.length) <= 1200
        if (maxCharacters){
            return true
        }else{
            return false
        }
    }
    
    func resetButton(){
        
        modal?.descritionTextView.text = ""
        modal?.heightDescriptionConstraint.constant = 28
        disableAcceptButton()
    }
  
    func enableAcceptButton(){
        UIView.animate(withDuration: 0.3) {
            self.modal?.acceptButton.backgroundColor = UIColor .AppColor.Blue.blueDinosaur
            self.modal?.acceptButton.titleColor = UIColor  .white
            self.modal?.acceptButton.layer.borderWidth = 0.0
        }
    }
    
    func disableAcceptButton(){
     UIView.animate(withDuration: 0.3) {
        MainHelper.giveMeStyle(button: self.modal!.acceptButton)
        self.modal!.acceptButton.backgroundColor = UIColor .white
        }
    }
    
    
    func acceptButton(){
        let text = modal!.descritionTextView.text
        modal?.returnDataCompleteHouse!(text!)
        
    }
}
