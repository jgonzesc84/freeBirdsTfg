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
    
    
    
    var controller : AddExpenseController?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        controller = AddExpenseController(view:self)
    }
    
    func initView(){
        prepareNav(label: titleLabel, text: "Añadir Gastos")
        MainHelper.navStyle(view:navView)
        
    }


  
}
