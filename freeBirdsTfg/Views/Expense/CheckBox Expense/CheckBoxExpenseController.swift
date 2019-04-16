//
//  CheckBoxExpenseController.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

struct CheckBoxExpenseController{
    
    var view : CheckBoxExpenseView?
    
    init(view:CheckBoxExpenseView){
        self.view = view
    }
    
    func boxtouch(){
        UIView.animate(withDuration: 0.1
            , animations: {
                self.boxSetup()
        }) { (finished: Bool) in
            
        }
    }
    func deselectAction(contentView:UIView, subView:UIView){
        let frame = contentView.frame
        let frameVariable = CGRect(x: frame.size.height / 2, y:frame.size.width / 2, width: 0, height: 0)
        subView.frame = frameVariable
        subView.backgroundColor = UIColor .white
        MainHelper.circleView(view: subView)
    }
    func selecAction(contentView:UIView, subView:UIView){
        let frame = contentView.frame
        subView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height:frame.size.height)
        subView.backgroundColor = UIColor .AppColor.Green.greenDinosaur
        MainHelper.circleView(view: subView)
    }
    func boxSetup() {
        if(view!.variableSelection){
            deselectAction(contentView: view!.variableCB, subView: view!.innnerVariable)
            selecAction(contentView:  view!.fixedCB, subView:  view!.innerFixed)
            view?.variableSelection = false
        }else{
            deselectAction(contentView: view!.fixedCB, subView: view!.innerFixed)
            selecAction(contentView:  view!.variableCB, subView:  view!.innnerVariable)
            view?.variableSelection = true
        }
    }
}
