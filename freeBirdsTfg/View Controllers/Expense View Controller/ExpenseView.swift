//
//  ExpenseView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ExpenseView: BaseViewController , UITableViewDelegate, UITableViewDataSource, RefreshHouseData, BillProtocol{
 
    
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var controller : ExpenseController?
    var arrayBill : Array<ModelBill>?
    var firstTime = true
    var widthScreen : Float?
     let billManager = BillManager()
    override func viewDidLoad() {
        
        super.viewDidLoad()
         controller = ExpenseController(view:self)
         initView()
         setuptable()
         firstTime = true
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
      //  refresh()
    
    }
    func initView(){
        prepareNavRoot(label: titlelabel, text: "Gastos")
        MainHelper.navStyle(view:navView)
        if let arrayBill = HouseManager.sharedInstance.house?.listOfBill{
        let  listOrdered =  BillManager().compareDate(listArray:arrayBill)
            self.arrayBill = listOrdered
            controller?.setupBill(listOfBill:listOrdered)
            if listOrdered.count > 0{
                let idBill = listOrdered[0].billId
                observerBillChanges(idBill!)
            }

        }else{
            self.arrayBill = [ModelBill]()
        }
       
    }

    func setuptable(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle .none
        self.tableView.estimatedRowHeight = 400
        self.tableView.register(UINib(nibName:"AddExpenseCell", bundle: nil), forCellReuseIdentifier: "addExpense")
       
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBill!.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //CGFloat(constant.billCellHeight * Double(numberExpense)) + CGFloat(constant.sectionExpenseHeight) + CGFloat(constant.billPaddingTop)
        let bill = arrayBill![indexPath.row]
        let numberExpense = bill.expenses!.count
        let total = calculateHeight(numberExpense: numberExpense, expenses: bill.expenses!)
    return total
    }
    func refresh(){
   
    
}
    func calculateHeight(numberExpense: Int, expenses : [ModelExpense]) -> CGFloat{
        let totalSections = CGFloat(Double(constant.billheaderHeight) * Double(numberExpense))
        let paddingTopBot = CGFloat(constant.sectionExpenseHeight) + CGFloat(constant.billPaddingTop)
        var heightPayment = 0.00
        for expense in expenses{
            if let payments = expense.payment{
                 heightPayment = heightPayment + constant.billCellHeight * Double(payments.count)
            }
        }
        let total = totalSections + CGFloat(paddingTopBot) + CGFloat(heightPayment)
        return total
    }
    
    func billRefresh(bill: ModelBill) {
 
    }
    
    func billChange(){
       
    }
    
    func observerBillChanges(_ idBill: String){
        
        billManager.oberveBill(idBill) { (bill,change) in //coge la primera hay q poner observadores solo a la de este mes no a la
            if (change){
                //filtrar si seha cmabiado el usuario no tiene que mostrarse
                self.arrayBill![0] = bill;
                self.tableView.reloadData {
                    
                }
            }
        }
    }
   
}
