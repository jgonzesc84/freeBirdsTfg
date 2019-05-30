//
//  BillManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON
class BillManager : BaseManager{
    
    
    
    func parseBill(json:JSON) -> ModelBill{
        let model = ModelBill()
        model.billId = json["billId"].string
        let dateInt = json["dateBill"].intValue
        model.dateBill = Date(milliseconds: dateInt)
        model.total = json["total"].double ?? 0.0
        if let expenseData = json ["expense"].dictionary{
            var expenses = [ModelExpense]()
            expenseData.compactMap{ expenseData -> Void in
                let expense = ModelExpense()
                 let values = expenseData.value
                expense.idBill = expenseData.key
                expense.idExpense = values["idExpense"].string
                expense.idUser = values["iduser"].string
                expenses.append(expense)
        }
           model.expenses = expenses
            
        }else{
            model.expenses = [ModelExpense]()
        }
        
        return model
    }
    
    func createPayment(users:[ModelUser], quantify: Double ) -> [ModelPayment]{
        var payments = [ModelPayment]()
        let totalPerUser = quantify / Double(users.count)
       let ref = Database.database().reference()
        for user in users{
            let pay = ModelPayment()
            pay.idUser = user.idUser;
            pay.quantify = totalPerUser
            pay.idPayment = ref.childByAutoId().key
            payments.append(pay)
        }
        
        return payments
    }
    
    
    func createDate() -> (Date){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        let result = formatter.string(from: date)
        let finishDate = formatter.date(from: result)
        return finishDate!
 
    }
    func stringFromDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        return result
    }
    
    func compareDate(listArray:Array<ModelBill>) -> Array<ModelBill>{
      let sortedArray = listArray.sorted(by: { $0.dateBill!.compare($1.dateBill!) == .orderedDescending })
        return sortedArray
    }
    
    func oberveBill(){
         let billRef = Database.database().reference().child("BILL")
        billRef.child("idBill").child("expense").observe(.value) { (shot) in
            
        }
    }
}
