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
                   // self.testTetxtView(show: true)
                  //  self.testTetxtField(show: true)
                }
               
            }
        }else{
            UIView.animate(withDuration: 1
                , animations: {
                    originalFrame.size.height -= 25
                    originalFrame.size.width -= 25
                  self.frame = originalFrame
                  self.testLabel(show: false)
                  //  self.testTetxtView(show: false)
                 //   self.testTetxtField(show:false)
            }) { (finished: Bool) in
                
            }
        }
        
        
        
    }
    
    func testLabel(show:Bool){
        let text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable."
        let screenSize: CGRect = UIScreen.main.bounds
       // let widtScreen = screenSize.size.width * 0.7
        let widtScreenMain = screenSize.size.width * 0.8
        let heightText = text.height(constraintedWidth: widtScreenMain, font: UIFont .AppFont.middleFont.middlWord!)
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
            self.selectedLabel.text = text
            self.selectedLabel.numberOfLines = 0
            self.selectedLabel.textAlignment = .center
            self.selectedLabel.font = UIFont .AppFont.middleFont.middlWord
            self.selectedLabel.textColor = UIColor .AppColor.Gray.greyCancel
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
    
    func testTetxtView(show:Bool){
        let text = "Buenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!\nBuenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!\nBuenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!"
        let screenSize: CGRect = UIScreen.main.bounds
        let widtScreen = screenSize.size.width * 0.8
        if(show){
            let frame = CGRect (x: 0, y: 0, width: widtScreen, height: text.height(constraintedWidth: widtScreen, font: UIFont .AppFont.middleFont.middlWord!))
            self.selectedTextView.frame = frame
            self.selectedTextView.text = text
           // self.selectedLabel.numberOfLines = 0
            self.selectedTextView.textAlignment = .center
            self.selectedTextView.font = UIFont .AppFont.middleFont.middlWord
            self.selectedTextView.backgroundColor = UIColor.white .withAlphaComponent(1)
            self.selectedTextView.layer.borderColor = UIColor.darkGray.cgColor
            self.selectedTextView.layer.borderWidth = 2
            self.selectedTextView.layer.cornerRadius = 5
            self.selectedTextView.layer.masksToBounds = true
            self.selectedTextView.center.x = 0.5 * self.frame.size.width;
            self.selectedTextView.center.y = -0.5 * self.selectedLabel.frame.height;
            self.addSubview(self.selectedTextView)
        }else{
            self.selectedTextView.removeFromSuperview()
        }
        
    }
   
    func testTetxtField(show:Bool){
        let text = "Buenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!\nBuenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!\nBuenas Buscamos compañeros simpáticos, a poder ser estudaintes entre 20 - 25 años, no fumadores somo simpaticos y con ganas de fiesta!!"
        let screenSize: CGRect = UIScreen.main.bounds
        let widtScreen = screenSize.size.width * 0.8
        if(show){
             let frame = CGRect (x: 0, y: 0, width: widtScreen, height: text.height(constraintedWidth: widtScreen, font: UIFont .AppFont.middleFont.middlWord!))
            self.selectedTextField.isUserInteractionEnabled = false
            self.selectedTextField.frame = frame
            self.selectedTextField.text = text
            // self.selectedLabel.numberOfLines = 0
            self.selectedTextField.textAlignment = .center
            self.selectedTextField.font = UIFont .AppFont.middleFont.middlWord
            self.selectedTextField.backgroundColor = UIColor.white .withAlphaComponent(1)
            self.selectedTextField.layer.borderColor = UIColor.darkGray.cgColor
            self.selectedTextField.layer.borderWidth = 2
            self.selectedTextField.layer.cornerRadius = 5
            self.selectedTextField.layer.masksToBounds = true
            self.selectedTextField.center.x = 0.5 * self.frame.size.width;
            self.selectedTextField.center.y = -0.5 * self.selectedLabel.frame.height;
            self.addSubview(self.selectedTextField)
        }else{
            self.selectedTextField.removeFromSuperview()
        }
        
    }
}
