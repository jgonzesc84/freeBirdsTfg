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
        
    }
    @IBAction func iconAction(_ sender: Any) {
       // returnAction!()
        
    }
    
    @IBAction func colorAction(_ sender: Any) {
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        self.modalView?.loadContentView(name: "addExpenseIco")
        if let topVC = UIApplication.getTopMostViewController() {
            UIView.transition(with:   topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
               topVC.view.addSubview(self.modalView!)
            }, completion: nil)
        }
          listener()
    }
    
    func listener(){
        modalView?.returnExpenseColour = { (data) -> () in
            switch data {
            case is UIColor:
               self.colorButton.backgroundColor = data as? UIColor
               if let topVC = UIApplication.getTopMostViewController() {
                UIView.transition(with: topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.modalView!.removeFromSuperview()
                }, completion: nil)
//                UIView.transition(with: topVC.view!, duration: 0.25, options: [.transitionCrossDissolve], animations: {
//                    self.modalView?.backgroundColor = UIColor .clear
//                }, completion: { (Bool) in
//                     self.modalView!.removeFromSuperview()
//                })
               }
                break;
            case is UIImage:
                self.icoButton.imageView?.image = data as? UIImage
                break;
            default:
                
                break;
            }
        }
        
    }
    
}
