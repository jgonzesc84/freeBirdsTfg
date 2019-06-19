//
//  TableViewCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class AddExpenseCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource,RefreshHouseData,RefreshExpense,sectionExpenseProtocol{
    
    
   
    
   
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
        tableView.register(UINib(nibName:"ExpenseSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "ExpenseSection")
        tableView.separatorStyle = .none
        model?.expenses = reOrderList()
        HouseManager.sharedInstance.delegateRefresh = self
        
        
        MainHelper.circleView(view: addButton)
        MainHelper.borderShadowRedonde(view: addButton)
        addButton.backgroundColor = UIColor .AppColor.Green.mindApp
       
        labelMont.textColor = UIColor .AppColor.Gray.greyStrong
        labelMont.font = UIFont .AppFont.titleFont.middletitleFont
       // let test =  colorExpense.color3.rawValue
        topViewBackground.backgroundColor = UIColor .AppColor.Gray.greyCancel
        MainHelper.borderShadowRedonde(view: mainView)
        
      
       
        

    }
    func setupCell(model: ModelBill){
        self.model = model
        self.refreshTotalLabel()
        refresh()
    }
    func refresh() {
        model?.expenses = reOrderList()
        tableView.reloadData {
            
        }
    }
    func setupTable(){
       
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        numberItem = 0
                if let list = model?.expenses{
                    numberItem = list.count
                }
        return numberItem!
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return CGFloat(Double(constant.billCellHeight))
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat(Double(constant.billheaderHeight));
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionExpense  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpenseSection") as! ExpenseSection
        let index = section
        if let sectionModel = model?.expenses![index]{
            sectionExpense.setupCell(model: sectionModel)
            sectionExpense.animation(percentage: givePercentage(item: sectionModel.quantify! / Double((sectionModel.payment?.count)!)))
        }
        sectionExpense.delegate = self
        return sectionExpense
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         numberItem = 0
        if let expenses = model?.expenses{
            let expense = expenses[section]
            if let payments = expense.payment{
                numberItem = payments.count
            }
        }
        return numberItem!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseBillCell", for: indexPath) as! ExpenseBillCell
        let expense = model!.expenses![indexPath.section]
        cell.setupCell(model:expense.payment![indexPath.row],color: expense.color!)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let expense = model!.expenses![indexPath.row]
//        self.pushToEditCellExpense!(expense, self.model!.total!)
    }
    
    func goToEditExpense(_ model: ModelExpense) {
         self.pushToEditCellExpense!(model, self.model!.total!)
    }
   
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal,
//                                              title: "Flag") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: @escaping (Bool) -> Void) in
//                                               let row = indexPath.row
//                                                let expense = self.model?.expenses![row]
//                                                HouseManager.sharedInstance.deleteExpenseOnBill(billId:self.model!.billId!, expenseId: expense!.idExpense!){
//                                                (result) in
//                                                    let total = self.model?.total
//                                                    let x = total! - expense!.quantify!
//                                                    self.model?.total = x.rounded(toPlaces: 2)
//
//                                                    self.refreshCell!()
//                                                    completionHandler(true)
//
//                                                }
//
//
//        }
//        let deleteIco = UIImage(named:"trash_ico")
//        deleteAction.image = deleteIco
//        deleteAction.backgroundColor = UIColor .gray
//        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
//        return swipeConfig
//    }

    func deleteExpense(_ model: ModelExpense) {
        HouseManager.sharedInstance.deleteExpenseOnBill(billId:self.model!.billId!, expenseId: model.idExpense!){
            (result) in
            let total = self.model?.total
            let x = total! - model.quantify!
            self.model?.total = x.rounded(toPlaces: 2)
            if let index = self.model?.expenses?.firstIndex(where: { $0.idExpense == model.idExpense
            }){
               self.model?.expenses?.remove(at: index)
            }
            
            self.refreshCell!()
            
        }
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
        let total = calculeTotal()
        var roundPercentage = 0
        if(total > 0){
            let percentage = item / total * 100
             roundPercentage = Int(round(percentage))
        }
       
        return roundPercentage
    }
    //delegate
    func refreshExpense(expense: ModelExpense) {
     
        let list = self.model?.expenses!
        if let index = list?.firstIndex(where: { ($0.idExpense == expense.idExpense)}){
            let oldItem =  self.model?.expenses![index]
            if oldItem?.quantify != expense.quantify{
                self.refreshTotalLabel()
                self.model?.expenses = self.reOrderList()
                self.tableView.reloadData {
                }
            }
            self.model?.expenses![index] = expense
            self.tableView.reloadData {
                
            }
        }
}

    func refreshTotalLabel(){
        if let comp = model?.dateBill{
            let date = BillManager().stringFromDate(date: comp, format: constant.formatTestDate)
            let compact = "\(date)  \(String(calculeTotal()))€"
            labelMont.text = compact
            
        }
        
       
    }
    func calculeTotal() -> Double{
        let expenses = model?.expenses
         var sum = 0.00
        for expense in expenses!{
            if let quantify = expense.quantify{
                sum += Double(quantify) / Double ((expense.payment?.count)!)
            }
            
        }
        return sum.rounded(toPlaces: 2)
    }

   
}


extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

extension UICollectionView{
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

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}
