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


protocol BillProtocol :class{
    
    func billRefresh(bill: ModelBill)
}
class BillManager : BaseManager{
    
    weak var delegate : BillProtocol?
    
    
    func parseBill(json:JSON) -> ModelBill{
        let model = ModelBill()
        model.billId = json["billId"].string
        let dateInt = json["dateBill"].intValue
        model.dateBill = Date(milliseconds: dateInt)
        model.total = json["total"].double ?? 0.0
        if let expenseData = json ["expense"].dictionary{
            var expenses = [ModelExpense]()
           _ = expenseData.compactMap{ expenseData -> Void in
                let expense = ModelExpense()
                 let values = expenseData.value
                expense.idBill = expenseData.key
                expense.idExpense = values["idExpense"].string
                expense.idUser = values["iduser"].string
                if let users = values["idUser"].dictionary{
                    var userList = [ModelUser]()
                _ = users.compactMap{userData -> Void in
                    let user = ModelUser()
                       // let values = userData.key
                        user.idUser =  userData.key
                        userList.append(user)
                    }
                    expense.users = userList
                }
                //exepsens.users = -> metod de parseo de la mierda de array Users
                expenses.append(expense)
        }
           model.expenses = expenses
            
        }else{
            model.expenses = [ModelExpense]()
        }
        
        return model
    }
    
    func parseExpense(json: JSON) -> ModelExpense{
        let expense = ModelExpense()
        expense.color = json["color"].string
        expense.ico = json["ico"].string
        expense.idBill = json["idBill"].string
        expense.idExpense = json["idExpense"].string
        expense.name = json["name"].string
        expense.quantify = json["quantify"].double
        expense.selection = json["selection"].bool
        return expense
    }
//    func parseExpense(json : JSON) -> ModelExpense{
//         var expenses = [ModelExpense]()
//    }
    
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
   
    func oberveBill(_ idBill: String,completion:@escaping(ModelBill) -> Void){
         let billRef = Database.database().reference().child("BILL")
        billRef.child(idBill).observe(.value) { (shot) in
            let json = JSON(shot.value as Any)
           let bill = self.parseBill(json: json)
            if let expenses = bill.expenses{
                // completion: { (listOfSuccess) in
                for item in expenses{
                    self.getExpenseBill(idReference: item.idExpense!, idUser: BaseManager().userId(),completion: {
                        (expense) in
                        bill.expenses?.append(expense)
                })
            }
          completion(bill)
        }
    }
    }
    //
    //    //   ref.child("BILL").child(idBill).child("expense").queryOrdered(byChild:"idUser").queryEqual(toValue: idUser).observe
    func getExpenseBill(idReference:String,idUser: String, completion:@escaping (ModelExpense) -> Void){
        let ref = Database.database().reference().child("EXPENSE")
        ref.child(idReference).observe(.value){
            (shot) in
             let json = JSON(shot.value as Any)
            let expense = self.parseExpense(json: json)
          completion(expense)
        }
        
    }
}
