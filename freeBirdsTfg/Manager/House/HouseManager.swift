//
//  HouseManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


protocol RefreshExpense: class{
    func refreshExpense(expense:ModelExpense)
}
protocol RefreshHouseData: class {
    func refresh()
}

class HouseManager : BaseManager{
    //gastos collection
     var user :  Array<ModelUser>?
     var house : ModelHouse?
    
     weak var delegate: RefreshHouseData?
    weak var delegateRefresh: RefreshExpense?
    
    static let sharedInstance = HouseManager()
    private override init (){}
    
    func setupData( completion:@escaping (Bool) -> Void){
      let idHouse = getUserDefault().houseId
        fillHouse(idHouse: idHouse ?? "default"){(finish) in
            if (finish){
             self.delegate?.refresh()
                completion(true)
            }
        }
    }
    
    func fillHouse(idHouse: String , completion:@escaping (Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).observe(.value, with: { (shot) in
            self.house = ModelHouse()
            let value = shot.value as? NSDictionary
            self.house = self.parseHouse(dictioHouse: value!)
            self.user = self.house?.user
            self.getListOfBill(list: self.house!.listOfBill!, completion: { (listOfSuccess) in
                self.house?.listOfBill = listOfSuccess
                completion(true)
            })
            
        }, withCancel: { (error) in
          
        })
    }
    
    
     func getListOfBill(list:Array<ModelBill>, completion:@escaping(Array<ModelBill>)-> Void){
        var completedList = Array<ModelBill>()
        var count = 0
        if list.count > 0{
            for item in list{
                getBillById(billId: item.billId!) { (model) in
                    if(model.expenses!.count > 0){
                        self.getListOfExpense(list: model.expenses!, completion: { (listOfExpense) in
                            model.expenses = listOfExpense
                            completedList.append(model)
                            count = count + 1
                            if(count == list.count){
                                completion(completedList)
                            }
                        })
                    }else{
                        completedList.append(model)
                        count = count + 1
                        if(count == list.count){
                            completion(completedList)
                        }
                    }
                }
            }
        }else{
            completion(completedList)
        }
        
        
    }
     func getBillById(billId: String , completion:@escaping(ModelBill)-> Void){
        
        let ref = Database.database().reference()
        ref.child("BILL").child(billId).observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let model = ModelBill()
            model.billId = billId
            model.total = value?["total"] as? Double ?? 0.0
            //
            if let dictioExpense = value?["expense"] as? Dictionary<String,Any>{
                model.expenses = self.getListOfExpense(dictio: dictioExpense)
            }else{
                model.expenses = Array()
            }
            //
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.yyyy"
            let date = dateFormatter.date(from: value?["Date"] as? String ?? "")
            model.dateBill = date
            completion(model)
           print("AQUI PASA ALGO")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getListOfExpense(list:Array<ModelExpense>, completion:@escaping(Array<ModelExpense>) -> Void){
        var completedList = Array<ModelExpense>()
        var count = 0
        if list.count > 0{
            for item in list{
                getExpenseById(expenseId: item.idExpense!) { (model) in
                    if(count < list.count){
                        completedList.append(model)
                        count = count + 1
                        if(count == list.count){
                            completion(completedList)
                        }
                    }else{
                        //se ha editado un campo ya existente
                        self.delegateRefresh?.refreshExpense(expense: model)
                    }
                    
                }
            }
        }else{
            completion(completedList)
        }
    }
    
   
    
    
    func getExpenseById(expenseId: String, completion:@escaping(ModelExpense) -> Void){
         let ref = Database.database().reference()
        ref.child("EXPENSE").child(expenseId).observe( .value, with: { (shot) in
            let value = shot.value as? NSDictionary
            guard let dictio = value, value != nil else{
                return
            }
            completion(self.getExpense(dictio:dictio,idExpense:expenseId))
        } , withCancel: { (error) in
    
    })
            
        }
    
    func fillUser(){
        //llamada recursiva para rellenar a todos los usuarios
    }
    
    func billSetTotal(total: Double,billId:String, completion:@escaping(Bool) -> Void){
         let ref = Database.database().reference()
        ref.child("BILL").child(billId).child("total").setValue(total){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
               completion(true)
            }
        }
    }
    func deleteExpenseOnBill(billId: String, expenseId: String, completion:@escaping(Bool) -> Void){
          let ref = Database.database().reference()
        ref.child("BILL").child(billId).child("expense").child(expenseId).removeValue { (error, ref) in
            if error != nil{
                completion(false)
            }else{
                ref.child("EXPENSE").child(expenseId).removeValue{ (error, ref) in
                    if error != nil{
                        completion(false)
                    }else{
                        completion(true)
                    }
            }
            
        }
    }
    func getBillUpdated(chilId:String,completion: @escaping(ModelBill,Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("BILL").child(chilId).observe(.childAdded) { (shot) in
            var bill = ModelBill()
            if let data = shot.value as? NSDictionary{
                //bill = self.parseBill
            }
        }
    }
    /*
     func getHouseUpdated(completion: @escaping (ModelHouse,Bool) -> Void){
     let ref = Database.database().reference()
     ref.child("CASA").queryLimited(toLast: 1).observe(.childAdded, with:{ shot in
     var fullHouse = ModelHouse()
     if let data = shot.value as? NSDictionary {
     fullHouse = self.parseHouse(dictioHouse: data)
     }
     completion(fullHouse,true)
     })
     ref.child("CASA").observe(.childRemoved, with:{ shot in
     var fullHouse = ModelHouse()
     if let data = shot.value as? NSDictionary {
     fullHouse = self.parseHouse(dictioHouse: data)
     }
     completion(fullHouse,false)
     })
     }
 
 */
}
}
