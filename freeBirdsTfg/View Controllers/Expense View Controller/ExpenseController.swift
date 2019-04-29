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
    
    func didSelectRow(tableView: UITableView, indexPath: IndexPath){
        let billId = self.view?.arrayBill![indexPath.row].billId
        let vc = AddExpenseView (nibName:"AddExpenseView", bundle: nil)
        vc.idBill = billId
        vc.hidesBottomBarWhenPushed = true;
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func drawCell(tableView: UITableView, indexPath: IndexPath)-> UITableViewCell{
        let cell : AddExpenseCell = tableView.dequeueReusableCell(withIdentifier: "addExpense", for: indexPath) as! AddExpenseCell
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
       model.total = "0.0"
        FireBaseManager.createBill(model: model){ (success) in
            if(success){
                self.view?.arrayBill?.append(model)
                self.view?.tableView.reloadData()
            }else{
                //error
            }
        }
        
    }
    func compareDate(listArray:Array<ModelBill>){
          //self.view?.arrayBill? = listArray.sorted(by: { $0.dateBill!.compare($1.dateBill!) == .orderedDescending })
          self.view?.arrayBill? = BillManager().compareDate(listArray:listArray)
          self.view?.tableView.reloadData()
        
    }
    
    func  actualize(){
        if let array = HouseManager.sharedInstance.house!.listOfBill{
             self.view?.arrayBill! =  BillManager().compareDate(listArray:array)
             self.view?.tableView.reloadData()
        }
       
        
    }

}
