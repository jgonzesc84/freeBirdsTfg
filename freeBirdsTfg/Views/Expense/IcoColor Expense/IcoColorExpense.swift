//
//  IcoColorExpense.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class IcoColorExpense: UIView {

    @IBOutlet var contentView: UIView!
    var modalView : ModalMain?
   // var returnAction: (() -> ())?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var icoButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    var colorSelected : String?
    var icoSelected : String?
    var initialColor = colorExpense.color1.rawValue
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
      
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("IcoColorExpense", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        MainHelper.theStyle(view: mainView)
        MainHelper.circleButton(button: icoButton)
        MainHelper.circleButton(button: colorButton)
        colorSelected = colorExpense.color1.rawValue
        icoSelected = icoExpense.ico1.rawValue
        colorButton.backgroundColor =  UIColor().colorFromHex(initialColor)
    }
    
    func setupEdit(_ color: String, _ ico: String){
        colorButton.backgroundColor = UIColor().colorFromHex(color)
        self.colorSelected = color
        self.icoButton.setImage(UIImage (named: ico), for: UIControl.State .normal)
        icoSelected = ico
        }
    
    @IBAction func iconAction(_ sender: Any) {
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        self.modalView?.loadContentView(name: "addExpenseIco")
        if let topVC = UIApplication.getTopMostViewController() {
            UIView.transition(with:   topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                topVC.view.addSubview(self.modalView!)
            }, completion: nil)
        }
        listenerIco()
    }
        
    
    
    @IBAction func colorAction(_ sender: Any) {
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        self.modalView?.loadContentView(name: "addExpenseColor")
        if let topVC = UIApplication.getTopMostViewController() {
            UIView.transition(with:   topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
               topVC.view.addSubview(self.modalView!)
            }, completion: nil)
        }
          listenerColor()
    }
    
    func listenerColor(){
        modalView?.returnExpenseColour = { (data) -> () in
            self.colorSelected = data
            self.colorButton.backgroundColor =  UIColor().colorFromHex(data)
            if let topVC = UIApplication.getTopMostViewController() {
                UIView.transition(with: topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.modalView!.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    func listenerIco(){
        modalView?.returnExpenseIco = { (data) -> () in
            let path = data
            self.icoSelected = data
            self.icoButton.setImage(UIImage (named: path), for: UIControl.State .normal)
            if let topVC = UIApplication.getTopMostViewController() {
                UIView.transition(with: topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.modalView!.removeFromSuperview()
                }, completion: nil)
            }
        }
    
}

}
