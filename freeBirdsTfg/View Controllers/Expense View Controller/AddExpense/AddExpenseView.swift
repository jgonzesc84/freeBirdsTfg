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
    var bill : ModelBill?  //-> idFactura para ingresarlo en firabase
    var editExpense : ModelExpense?
    var controller : AddExpenseController?
    var modalView : ModalMain?
    var editMode : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        controller = AddExpenseController(view:self)
        hideKeyboardWhenTappedAround()
    }
    
   
    func initView(){
        var titleNav = "Añadir Gastos"
        MainHelper.navStyle(view:navView)
        buttonView.delegate = self
        editMode = editExpense != nil ? true : false
        if(editMode!){
            setupEdit(editExpense!)
            titleNav = "Editar Gastos"
        }
        prepareNav(label: titleLabel, text: titleNav)
    }
    
    func confirm() {
        listenSubView()
    }
    
    func setupEdit(_ expense : ModelExpense){
        textView.nameTextField.text = expense.name
        textView.quantifyTextField.text = "\(expense.quantify!)"
     //   checkBoxView.variableSelection = expense.selection!
        checkBoxView.setupEdit(expense.selection!)
        icoColorView.setupEdit(expense.color!, expense.ico!)
        
    }
  
    func listenSubView(){
        guard let name = textView.nameTextField.text, isValid(text: name) else{
       
            self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
            self.modalView?.loadContentView(name: "errorText")
            self.modalView?.loadError(text:"Debe rellenar el campo Nombre")
            self.view.addSubview(modalView!)
            
            return
        }
        
        guard let quantify = textView.quantifyTextField.text, isValid(number: quantify)else{
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
        expense.quantify = (quantify as NSString).doubleValue
        expense.selection = payment
        expense.color = color
        expense.ico = ico
        expense.users = usersSelected
        expense.idBill = bill?.billId
        expense.idExpense = editExpense?.idExpense ?? ""
        editMode! ? editExpense(expense) : createExpense(expense)
        
            }
    
    func createExpense( _ expense: ModelExpense){
        FireBaseManager.createExpense(model:expense) { (success) in
            if(success){
                self.bill!.total! = self.refreshBillAdd(expense.quantify!)
                HouseManager.sharedInstance.billSetTotal(total: self.bill!.total!, billId: self.bill!.billId!){ (result) in
                    if(result){
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func editExpense(_ expense: ModelExpense){
        FireBaseManager.editExpense(model: expense){ (sucess) in
            if(sucess){
                if (expense.quantify != self.editExpense?.quantify){
                    self.bill!.total! = self.refreshBillEdit(expense.quantify!, self.editExpense!.quantify!)
                    HouseManager.sharedInstance.billSetTotal(total: self.bill!.total!, billId: self.bill!.billId!){ (result) in
                        if(result){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    func refreshBillAdd(_ e: Double) -> Double{
        let a = self.bill!.total!
        let x = e + a
       return x.rounded(toPlaces: 2)
    }
    func refreshBillEdit(_ a: Double, _ b: Double) -> Double{
        let c = a - b
        var x = self.bill!.total!
        x = x + c
        return x.rounded(toPlaces: 2);
    }
    
   
    func isValid(text: String) -> Bool{
        var comprobation = false
        if(text.count > 0){
        comprobation  = true
        }
        return comprobation
    }
    func isValid(number: String) -> Bool{
         var comprobation = false
         let numberDouble = (number as NSString).doubleValue
            if (numberDouble > 0){
                comprobation = true
            }
         return comprobation
        }
    }
    

