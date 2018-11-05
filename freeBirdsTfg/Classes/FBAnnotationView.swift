//
//  FBAnnotationView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import MapKit
import Material

class FBAnnotationView : MKAnnotationView{
    
 //   let selectedLabel:UILabel = UILabel.init(frame:CGRect(x: 0, y: 0, width: 140, height: 38))
    let selectedLabel:UILabel = UILabel()
    let selectedTextField : UITextField = UITextField()
    let selectedTextView: UITextView = UITextView()
    let vistaTest = UIView()
    var descriptionText = "HOLA!!"
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        
        super.setSelected(false, animated: animated)
        var originalFrame = frame
        if(selected){
            UIView.animate(withDuration: 1
                , animations: {
                    originalFrame.size.height += 25
                    originalFrame.size.width += 25
                    self.frame = originalFrame
                    
            }) { (finished: Bool) in
                UIView.animate(withDuration: 0.5) {
                    self.testLabel(show: true)
                }
                
            }
        }else{
            UIView.animate(withDuration: 1
                , animations: {
                    originalFrame.size.height -= 25
                    originalFrame.size.width -= 25
                    self.frame = originalFrame
                    self.testLabel(show: false)
            }) { (finished: Bool) in
                
            }
        }
        
        
        
    }
    
    func testLabel(show:Bool){
        let screenSize: CGRect = UIScreen.main.bounds
        let widtScreenMain = screenSize.size.width * 0.8
        let heightText = descriptionText.height(constraintedWidth: widtScreenMain, font: UIFont .AppFont.middleFont.middlWord!)
        let zeroFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if(show){
            let frame = CGRect (x: 0  , y: 0 , width: widtScreenMain, height: heightText  + 5)
            let frameLabel = CGRect(x: 5, y: 5, width: widtScreenMain-5, height: heightText)
            self.vistaTest.frame = frame
            self.selectedLabel.frame = frameLabel
            self.vistaTest.backgroundColor = UIColor .white
            self.vistaTest.layer.borderColor = UIColor .AppColor.Gray.greyApp.cgColor
            self.vistaTest.layer.borderWidth = 1.0
            MainHelper.borderShadow(view: self.vistaTest)
            self.selectedLabel.text = descriptionText
            self.selectedLabel.numberOfLines = 0
            self.selectedLabel.textAlignment = .center
            self.selectedLabel.font = UIFont .AppFont.middleFont.middlWord
            self.selectedLabel.textColor = UIColor .AppColor.Blue.blueHouse
           self.vistaTest.addSubview(self.selectedLabel)
           self.vistaTest.center.x = 0.5 * self.frame.size.width;
           self.vistaTest.center.y = -0.5 * vistaTest.frame.height;
           self.addSubview(self.vistaTest)
        }else{
            //quitar zero frame si la animacion molesta!!
             self.vistaTest.frame = zeroFrame
             self.selectedLabel.frame =  zeroFrame
             self.vistaTest.removeFromSuperview()
        }
       
    }
    
}
