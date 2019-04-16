//
//  AddExpenseView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class AddExpenseView: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var icoColor: IcoColorExpense!
    var modalView : ModalMain?
    var controller : AddExpenseController?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        controller = AddExpenseController(view:self)
    }
    
    func initView(){
        prepareNav(label: titleLabel, text: "Añadir Gastos")
        MainHelper.navStyle(view:navView)
        icoColor.returnAction = { () ->()in
            self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
            self.modalView?.loadContentView(name: "addExpenseIco")
            self.view.addSubview(self.modalView!)
        }
    }
    
    
    /*
     getTopMostViewController
     let vc = AddExpenseView (nibName:"AddExpenseView", bundle: nil)
     vc.hidesBottomBarWhenPushed = true;
     view?.navigationController?.pushViewController(vc, animated: true
     modalRequestHouse?.returnDataRequestHouse = { (text) -> () in
     self.modal?.returnRequestHouseData?(text)
     self.modal?.removeFromSuperview()
     }
     */
  
}
