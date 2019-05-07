//
//  TableViewCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class AddExpenseCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource,RefreshHouseData,RefreshExpense{
   
    var refreshCell : (() -> ())?
    var pushToCellExpense :( () -> ())?
    var pushToEditCellExpense: ((ModelExpense, Double)->())?
    var model : ModelBill?
    var numberItem :Int?
    
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var addButton: UIButton!
   
    @IBOutlet weak var topViewBackground: UIView!
    @IBOutlet weak var labelMont: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .none
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "ExpenseBillCell", bundle: nil), forCellReuseIdentifier: "expenseBillCell")
        tableView.separatorStyle = .none
        model?.expenses = reOrderList()
        HouseManager.sharedInstance.delegateRefresh = self
        
        
        MainHelper.circleView(view: addButton)
        MainHelper.borderShadowRedonde(view: addButton)
        addButton.backgroundColor = UIColor .AppColor.Green.mindApp
       
        labelMont.textColor = UIColor .AppColor.Gray.greyStrong
        labelMont.font = UIFont .AppFont.titleFont.middletitleFont
        let test =  colorExpense.color3.rawValue
        topViewBackground.backgroundColor = UIColor().colorFromHex(test)
        MainHelper.borderShadowRedonde(view: mainView)
        
      
       
        

    }
    func setupCell(model: ModelBill){
        self.model = model
     //   totalLabel.text = String(model.total!)
        //myDate.asString(style: .medium)
        let compact = "\(model.dateBill!.asString())  \(String(model.total!.rounded(toPlaces: 2)))"
        labelMont.text = compact
        refresh()
    }
    func refresh() {
        model?.expenses = reOrderList()
        tableView.reloadData {
        }
    }
    func setupTable(){
       
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return CGFloat(Double(constant.billCellHeight))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         numberItem = 0
        if let list = model?.expenses{
            numberItem = list.count
        }
        return numberItem!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseBillCell", for: indexPath) as! ExpenseBillCell
        let expense = model!.expenses![indexPath.row]
        cell.setupCell(model:expense)
        cell.animation(percentage: givePercentage(item: expense.quantify!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let expense = model!.expenses![indexPath.row]
        self.pushToEditCellExpense!(expense, self.model!.total!)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
   
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Flag") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: @escaping (Bool) -> Void) in
                                               let row = indexPath.row
                                                let expense = self.model?.expenses![row]
                                                HouseManager.sharedInstance.deleteExpenseOnBill(billId:self.model!.billId!, expenseId: expense!.idExpense!){
                                                (result) in
                                                    let total = self.model?.total
                                                    let x = total! - expense!.quantify!
                                                    self.model?.total = x.rounded(toPlaces: 2)
                                                    HouseManager.sharedInstance.billSetTotal(total: self.model!.total!, billId: self.model!.billId!){ (result) in
                                                        if result{
                                                            self.model?.expenses!.remove(at: row)
                                                            self.refreshCell!()
                                                            completionHandler(true)
                                                        }
                                                    }
                                               
                                                }
                                                
                                               
        }
        let deleteIco = UIImage(named:"trash_ico")
        deleteAction.image = deleteIco
        deleteAction.backgroundColor = UIColor .gray
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    
    @IBAction func addExpense(_ sender: Any) {
        self.pushToCellExpense!()
        
    }
    
    func reOrderList() -> Array<ModelExpense>{
        var orderedList = Array<ModelExpense>()
        let list = model?.expenses
        if list!.count > 1{
            orderedList = list!.sorted(by: {Double($0.quantify!) > Double($1.quantify!)})
        }else{
            orderedList = list!
        }
        
      return orderedList
    }
    
    func givePercentage(item:Double) -> Int{
        let total = model?.total
        let percentage = item / total! * 100
        let roundPercentage = Int(round(percentage))
        return roundPercentage
    }
    //delegate
    func refreshExpense(expense: ModelExpense) {
     
        let list = self.model?.expenses!
        if let index = list?.firstIndex(where: { ($0.idExpense == expense.idExpense)}){
            let oldItem =  self.model?.expenses![index]
            if oldItem?.quantify != expense.quantify{
                let oldImport = oldItem?.quantify
                let newImport = expense.quantify
                var total =  self.model!.total!
                total = total - oldImport!
                total = total + newImport!
                self.model?.total = total
                HouseManager.sharedInstance.billSetTotal(total: self.model!.total!, billId: self.model!.billId!){ (result) in
                    if(result){
                        
                        self.model?.expenses![index] = expense
                        self.refreshTotalLabel()
                        self.model?.expenses = self.reOrderList()
                        self.tableView.reloadData {
                        }
                    }else{
                       
                    }
                }
            }
            self.model?.expenses![index] = expense
            self.tableView.reloadData {
                
            }
        }
}

    func refreshTotalLabel(){
        let compact = "\(model!.dateBill!.asString())  \(String(model!.total!))€"
        labelMont.text = compact
    }
    
   
}


extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

extension Date {
    func asString() -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMMM yyyy";
        let mydt = dateFormatter1.string(from: self)
       
        return mydt
    }
}

extension Date {
        var millisecondsSince1970:Int64 {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
            //RESOLVED CRASH HERE
        }
        
        init(milliseconds:Int) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
