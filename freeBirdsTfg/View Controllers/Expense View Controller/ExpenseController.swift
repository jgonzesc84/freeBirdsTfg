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
       model.dateBill = BillManager().createDate()
       model.total = 0.0
        FireBaseManager.createBill(model: model){ (success) in
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
          self.view?.tableView.reloadData()
        
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
