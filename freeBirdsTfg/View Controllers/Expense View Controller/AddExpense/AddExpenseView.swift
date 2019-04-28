//
//  AddExpenseView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class AddExpenseView: BaseViewController, confirmProtocol {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var icoColor: IcoColorExpense!
    
    ////views
    
    @IBOutlet weak var textView: QuantifyView!
    @IBOutlet weak var checkBoxView: CheckBoxExpenseView!
    @IBOutlet weak var icoColorView: IcoColorExpense!
    @IBOutlet weak var asignationView: PayGroupCollectionView!
    @IBOutlet weak var buttonView: ConfirmExpenseView!
    
    //model
    
    //tiene que tener un objeto factura para asignar el gasto
    var idBill : String?  //-> idFactura para ingresarlo en firabase
    var controller : AddExpenseController?
    var modalView : ModalMain?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        controller = AddExpenseController(view:self)
    }
    
    func initView(){
        prepareNav(label: titleLabel, text: "Añadir Gastos")
        MainHelper.navStyle(view:navView)
        buttonView.delegate = self
    }
    
    func confirm() {
        listenSubView()
    }
  
    func listenSubView(){
        /*
         self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
         modalView?.loadContentView(name: name)
         if let topVC = UIApplication.getTopMostViewController() {
         topVC.view.addSubview(self.modalView!)
 */
        guard let name = textView.nameTextField.text, isValid(text: name) else{
       
            self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
            self.modalView?.loadContentView(name: "errorText")
            self.modalView?.loadError(text:"Debe rellenar el campo Nombre")
            self.view.addSubview(modalView!)
            
            return
        }
        
        guard let quantify = textView.quantifyTextField.text, isValid(text: quantify)else{
            self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
            self.modalView?.loadContentView(name: "errorText")
            self.modalView?.loadError(text:"Debe rellenar el campo Cantidad")
            self.view.addSubview(modalView!)
            return
        }
        let payment = checkBoxView.variableSelection
        let color = icoColorView.colorSelected
        let ico = icoColorView.icoSelected
        let usersSelected = asignationView.usersSelected
        
        let expense = ModelExpense()
        expense.name = name
        expense.quantify = quantify
        expense.selection = payment
        expense.color = color
        expense.ico = ico
        expense.users = usersSelected
        
        //subida a firebase necesitamos el id de la factura
        
    }
    
    func isValid(text: String) -> Bool{
        var comprobation = false
        if(text.count > 0){
        comprobation  = true
        }
        return comprobation
    }
    
    
    
}
