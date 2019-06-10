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
        expense.users = getUserJson(json: json["users"])
        expense.payment = parsePayment(json: json["payment"])
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
            pay.payed = 0.00
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
   
    func oberveBill(_ idBill: String,completion:@escaping(ModelBill,Bool) -> Void){
        let billRef = Database.database().reference().child("BILL")
        billRef.child(idBill).observe(.value) { (shot) in
            let json = JSON(shot.value as Any)
            let bill = self.parseBill(json: json)
            if let expenses = bill.expenses{
                let filterExpense = self.filterExpenseByUser(idUser: BaseManager().userId(), listExpsenses: expenses)
               let change = self.changeExpense(idUser: BaseManager().userId(), listExpsenses: expenses)
                 bill.expenses? = filterExpense
                    self.getExpenseBill(listExpense:filterExpense, idUser: BaseManager().userId(),completion: {
                        (list) in
                        bill.expenses = list
                       completion(bill,change)
                    })
                    
                
                
            }else{
                completion(bill,false)
            }
        }
    }
    func checkEdited(_ listExpense:[ModelExpense], expense:ModelExpense) -> Int{
         var indice = -1
        if let index = listExpense.index(where:{$0.idExpense == expense.idExpense}){
            indice = index
        }
       return indice
        
    }
    func observeAddeChild(_ idBill: String,completion:@escaping(ModelExpense) -> Void){
        let billRef = Database.database().reference().child("BILL")
        billRef.child(idBill).child("expense").observe(.childAdded){ (shot) in
            let json = JSON(shot.value as Any)
            let idExpense = json["idExpense"].string
            self.getExpenseBillOnce(idReference: idExpense!, completion: { (match,expense)  in
                if(match){
                    completion(expense)
                }else{
                    completion(ModelExpense())
                }
                
            })
          
        }
        
    }
    
    func observeRemoveExpenseBill(_ idBill: String,completion:@escaping(ModelExpense) -> Void){
    let billRef = Database.database().reference().child("BILL")
    billRef.child(idBill).child("expense").observe(.childRemoved){ (shot) in
        let json = JSON(shot.value as Any)
        let expense = self.parseExpense(json: json)
        completion(expense)
    }
    
    }
    
    
    
    func getExpenseBill(listExpense:[ModelExpense],idUser: String, completion:@escaping ([ModelExpense]) -> Void){
        let count = listExpense.count
        var aux = 0
        var listCompleted = listExpense
        for expense in listExpense{
            let ref = Database.database().reference().child("EXPENSE")
            ref.child(expense.idExpense!).observe(.value){
                (shot) in
                let json = JSON(shot.value as Any)
                let expense = self.parseExpense(json: json)
                let indexEdited = self.checkEdited(listExpense, expense: expense)
                if (indexEdited >= 0){
                    listCompleted[indexEdited] = expense
                }else{
                    listCompleted.append(expense)
                }
                aux += 1
                if (aux >= count){
                    completion(listCompleted)
                }
            }
        }
    }
    
    func getExpenseBillOnce(idReference:String,completion:@escaping (Bool,ModelExpense) -> Void){
        let ref = Database.database().reference().child("EXPENSE")
        ref.child(idReference).observeSingleEvent(of: .value){
            (shot) in
            let json = JSON(shot.value as Any)
            let expense = self.parseExpense(json: json)
            if (expense.users?.first(where: {$0.idUser == BaseManager().userId()})) != nil{
                completion(true,expense)
            }else{
                completion(false,ModelExpense())
            }
        }
        
    }
    
    func parsePayment(json: JSON) -> [ModelPayment]{
        var payments = [ModelPayment]()
        _ = json.dictionary?.compactMap{json -> Void in
        let payment = ModelPayment()
            let values = json.value
            payment.idPayment = values["idPayment"].string
            payment.idUser = values["idUser"].string
            payment.quantify = values["quantify"].double!
            payment.payed = values["payed"].double!
            payments.append(payment)
    }
        return payments
}
    func observeRemoveExpense(){
        
    }
    
    func filterExpenseByUser(idUser: String, listExpsenses:[ModelExpense]) -> [ModelExpense]{
        var expenseFiletered = [ModelExpense]()
            for expense in listExpsenses{
                if  (expense.users?.first(where: {$0.idUser == idUser})) != nil{
                    expenseFiletered.append(expense)
                }
                
            }
        return expenseFiletered;
    }
    
    func changeExpense(idUser: String, listExpsenses:[ModelExpense]) -> Bool{
        var change = false
        var expenseFiletered = [ModelExpense]()
        for expense in listExpsenses{
            if  (expense.users?.first(where: {$0.idUser == idUser})) != nil{
                expenseFiletered.append(expense)
                change = true;
                return change
            }
            
        }
        return change;
    }

}
