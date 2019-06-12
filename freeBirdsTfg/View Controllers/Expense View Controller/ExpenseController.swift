//
//  ExpenseController.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ExpenseController {
   
    var view : ExpenseView?
    
    init(view : ExpenseView){
        self.view = view;
        
    }
    
    func drawCell(tableView: UITableView, indexPath: IndexPath)-> UITableViewCell{
        let cell : AddExpenseCell = tableView.dequeueReusableCell(withIdentifier: "addExpense", for: indexPath) as! AddExpenseCell
        cellListener(cell, indexPath: indexPath)
        cell.setupCell(model: (self.view?.arrayBill![indexPath.row])!)
        return cell
      
    }
    //mal dno se deria poder cambiar el arry original
    func setupBill(listOfBill:Array<ModelBill>){
        listOfBill.count == 0 ?   createBill() : compareDate(listArray: listOfBill)

    }
    
    func createBill(){
       let model = ModelBill()
       model.expenses = Array<ModelExpense>()
       model.dateBill = Date()
       model.total = 0.0
        FireBaseManager.createBill(model: model){ (success, id) in
            if(success){
                self.view?.arrayBill?.append(model)
                self.view?.tableView.reloadData()
            }else{
               
            }
        }
        
    }
    func compareDate(listArray:Array<ModelBill>){
          //self.view?.arrayBill? = listArray.sorted(by: { $0.dateBill!.compare($1.dateBill!) == .orderedDescending })
        
        self.view?.arrayBill? = BillManager().compareDate(listArray:listArray)
        
        let date = Date()
        let calendar = Calendar.current
        let year =  calendar.component(.year, from: date)
        let moth  = calendar.component(.month, from: date)
        
        
        
        if  let lastBill = self.view?.arrayBill![0]{
            let dateLastBill = lastBill.dateBill
            let calendar = Calendar.current
            let lastYear =  calendar.component(.year, from: dateLastBill!)
            let lastMoth  = calendar.component(.month, from: dateLastBill!)
            if(lastYear == year){
                if(lastMoth < moth){
                    let bill = createNewBill(lastBill)
                    FireBaseManager.createBill(model: bill){ (success, id) in
                        if(success){
                            let expenses = self.checkVariablExpense(lastBill.expenses!,id)
                            let total = expenses.count
                            var count = 0
                            for expense in expenses{
                                FireBaseManager.createExpense(model:expense) { (exit) in
                                    if(exit){
                                        //                                         self.view?.arrayBill?.append(bill)
                                        //                                        let list =  self.view?.arrayBill!
                                        //                                        self.view?.arrayBill? = BillManager().compareDate(listArray:list!)
                                        // self.view?.tableView.reloadData()
                                        count = count + 1
                                        if(count == total){
                                            print("PUES YA ESTA")
                                            count = 0
                                            // self.view?.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                            
                            
                        }else{
                            print("ostia fallo")
                        }
                    }
                    print("a ver?")
                }
            }else if( lastYear <= year ){
                let bill = createNewBill(lastBill)
                 self.view?.tableView.reloadData()
            }
        }
        self.view?.tableView.reloadData()
        
    }
    
    func createNewBill(_ lastBill:(ModelBill)) -> ModelBill{
        //sacar los expense y mirar si hay fijo o variables si hay variable a 0
        let model = ModelBill()
        model.dateBill = Date()
        model.total = 0.0
//        if let oldExpense = lastBill.expenses{
//             let newExpense = checkVariablExpense(oldExpense)
//            model.expenses = newExpense
//        }
       
        return model
    }
    
    func checkVariablExpense(_ list:[ModelExpense], _ idBill: String) -> [ModelExpense]{
        var listReturned = list
        let ref = Database.database().reference()
        for expense in list{
            if (expense.selection! ){
                let index = list.firstIndex(where: {$0.idExpense == expense.idExpense})
                expense.quantify = 0
               let payments = resetPaymenExpense(expense.payment!)
                expense.payment?.removeAll()
                expense.payment = payments
                listReturned[index!] = expense
            }
        }
        _ = listReturned.map({$0.idExpense = ref.childByAutoId().key})
        _ = listReturned.map({$0.idBill = idBill})
        return listReturned
    }
    
    func resetPaymenExpense(_ list:[ModelPayment]) -> [ModelPayment]{
      _ = list.map({$0.quantify = 0.0})
     //   _ = list.map({$0.payed = 0.0})
        return list
    }
    
    func  actualize(){
        HouseManager.sharedInstance.setupData { (finish) in
            if(finish){
                if let array = HouseManager.sharedInstance.house!.listOfBill{
                    self.view?.arrayBill! =  BillManager().compareDate(listArray:array)
                    self.view?.tableView.reloadData()
                }
                
            }
        }
    }
    
    func actualizeBill(_ bill: ModelBill){
    let index = self.view?.arrayBill!.firstIndex(where: {$0.billId == bill.billId})
        self.view?.arrayBill![index!] = bill
       // self.view?.tableView.reloadData()
    
    }
    
    func cellListener(_ cell : AddExpenseCell, indexPath: IndexPath){
        cell.refreshCell = {() -> () in
            UIView.transition(with: self.view!.tableView!,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: {self.view!.tableView!.reloadData() })
        }
        cell.pushToCellExpense = { () -> () in
            let vc = AddExpenseView (nibName:"AddExpenseView", bundle: nil)
            vc.bill = self.view?.arrayBill![indexPath.row]
            vc.hidesBottomBarWhenPushed = true;
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.pushToEditCellExpense = { (expense,total) -> () in
            let vc = AddExpenseView (nibName:"AddExpenseView", bundle: nil)
            let bill = ModelBill()
            bill.billId = expense.idBill
            bill.total = total
            vc.bill = bill
            vc.editExpense = expense
            vc.hidesBottomBarWhenPushed = true;
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
