//
//  CheckBoxExpense.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class CheckBoxExpenseView: UIView {

    @IBOutlet weak var checkBox: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fixedCB: UIView!
    @IBOutlet weak var innerFixed: UIView!
    @IBOutlet weak var variableCB: UIView!
    @IBOutlet weak var innnerVariable: UIView!
    
    var  variableSelection : Bool = true
    var controller : CheckBoxExpenseController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit(){
        Bundle.main.loadNibNamed("CheckBoxExpenseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller = CheckBoxExpenseController(view:self)
        configureActionView()
        MainHelper.theStyle(view: checkBox)
        setupBox()
    }
    func setupBox(){
        MainHelper.circleView(view: fixedCB)
        MainHelper.circleView(view: innerFixed)
        MainHelper.borderShadowRedondNotRadius(view: fixedCB)
        MainHelper.circleView(view: variableCB)
        MainHelper.borderShadowRedondNotRadius(view: variableCB)
        MainHelper.circleView(view: innnerVariable)
        fixedCB.backgroundColor = UIColor .white
        variableCB.backgroundColor = UIColor .white
        innnerVariable.backgroundColor = UIColor .AppColor.Green.greenDinosaur
       
    }
    func configureActionView(){
        let gestureBox = UITapGestureRecognizer(target: self, action:  #selector(self.selectBox))
        self.fixedCB.addGestureRecognizer(gestureBox)
         let gestureFixBox = UITapGestureRecognizer(target: self, action:  #selector(self.selectBox))
        self.variableCB.addGestureRecognizer(gestureFixBox)
    }
    
    @objc func selectBox(sender:UITapGestureRecognizer){
        controller?.boxtouch()
    }
    
}
