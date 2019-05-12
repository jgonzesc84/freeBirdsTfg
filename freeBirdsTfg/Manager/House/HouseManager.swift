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
    var  theGreateye :  DatabaseHandle!
    var theReference : DatabaseReference!
    weak var delegate: RefreshHouseData?
    weak var delegateRefresh: RefreshExpense?
    
    static let sharedInstance = HouseManager()
    private override init (){}
    
    func setupDataBegining( completion:@escaping (Bool) -> Void){
        let idHouse = getUserDefault().houseId
        fillHouseFirstLoad(idHouse: idHouse ?? "default"){(finish) in
            if (finish){
               
                completion(true)
            }
        }
    }
    
    func fillHouseFirstLoad(idHouse: String , completion:@escaping (Bool) -> Void){
       let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).observeSingleEvent(of: .value, with: { (shot) in
            self.house = ModelHouse()
            let value = shot.value as? NSDictionary
            self.house = self.parseHouse(dictioHouse: value!)
            self.user = self.house?.user
            self.fillUserHouse(completion: { (listOfUser) in
                self.house!.user = listOfUser
                self.house?.listOfRoom = self.fillRoomWithuUser(rooms: (self.house?.listOfRoom)!, users: (self.house?.user)!)
                if(self.house?.listOfBill == nil){
                    let bills = Array<ModelBill>()
                    self.house!.listOfBill = bills
                }
                self.getListOfBill(list: self.house!.listOfBill!, completion: { (listOfSuccess) in
                    self.house?.listOfBill = listOfSuccess
                    completion(true)
                })
            })
        }, withCancel: { (error) in
            
        })
    }
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
         theReference = Database.database().reference()
      theGreateye = theReference.child("CASA").child(idHouse).observe(.value, with: { (shot) in
            self.house = ModelHouse()
            let value = shot.value as? NSDictionary
            self.house = self.parseHouse(dictioHouse: value!)
            self.user = self.house?.user
            self.fillUserHouse(completion: { (listOfUser) in
                self.house!.user = listOfUser
                self.house?.listOfRoom = self.fillRoomWithuUser(rooms: (self.house?.listOfRoom)!, users: (self.house?.user)!)
                if(self.house?.listOfBill == nil){
                    let bills = Array<ModelBill>()
                    self.house!.listOfBill = bills
                }
                self.getListOfBill(list: self.house!.listOfBill!, completion: { (listOfSuccess) in
                    self.house?.listOfBill = listOfSuccess
                    completion(true)
                })
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
                return //deveria ser un completion false
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
    }
    func getBillUpdated(chilId:String,completion: @escaping(ModelBill,Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("BILL").child(chilId).observe(.childAdded) { (shot) in
//            var bill = ModelBill()
//            if let data = shot.value as? NSDictionary{
//                //bill = self.parseBill
//            }
        }
    }
  
    func fillUserHouse(completion:@escaping(Array<ModelUser>) -> Void)  {
        let totalUser = house?.user?.count
        var count = 0
        var usersFilled = Array<ModelUser>()
        for user in house!.user!{
            if let id = user.idUser, user.idUser != nil && (user.idUser?.count)! > 0{
                getUserById(id) { (model) in
                    usersFilled.append(model)
                    count += 1
                    if(count == totalUser){
                        completion(usersFilled)
                    }
                }
            }
            
        }
    }

    func getUserById( _ idUser:String,completion: @escaping (ModelUser) -> Void){
        let ref = Database.database().reference()
        ref.child("USUARIO").child(idUser).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                let user =   self.getUserModel(value, idUser)
                completion(user)
            }else{
                completion(ModelUser())
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    //insertamos usario  en casa
    func setUserOnHouse(idUser: String, idHouse: String, completion:@escaping(Bool) -> Void){
           let ref = Database.database().reference()
        ref.child("USUARIO").child(idUser).child("houseId").setValue(idHouse){
             (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    func insertUser(request: ModelRequestHouse, userAplicant: Bool,completion:@escaping(Bool)-> Void){
       
        var dictio  = Dictionary<String,Any>()
        let ref = Database.database().reference()
        var idHouse = request.aplicantId
        var idUser = request.requiredId
        if(userAplicant){
            idUser = request.aplicantId!
            idHouse = request.requiredId!
        }
        dictio = self.prepareUserNoHouse(idUser : idUser!)
        ref.child("CASA").child(idHouse!).child("USER").child(idUser!).setValue(dictio){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
              completion(false)
            } else {
                
                var idHouse = request.aplicantId
                var idUser = request.requiredId
                if(userAplicant){
                    idUser = request.aplicantId!
                    idHouse = request.requiredId!
                }
                UserDefaults.standard.set(idHouse, forKey: BaseViewController.IDHOUSE)
                self.setUserOnHouse(idUser: idUser!, idHouse: idHouse!){ (succes) in
                    if(succes){
                        completion(true)
                    }else{
                         completion(false)
                    }
                    }
              
            }
        }
    }
    
    //sacar usuario de casa
    func deleteUserFromHouse(idHouse: String, idUser: String,completion:@escaping(Bool) -> Void){
        cancelEye()
        let ref = Database.database().reference()
        let userId = idUser
        ref.child("CASA").child(idHouse).child("USER").child(idUser).removeValue(){
              (error:Error?, ref:DatabaseReference) in
            if error != nil {
               
            } else {
                print(userId)
               // completion(true)
                self.deleteHouseInUser(idUser: userId){(sucess) in
                    completion(true)
                }
        }
    }
    
    }
    
    func deleteHouseInUser( idUser: String,completion:@escaping(Bool)-> Void){
           let ref = Database.database().reference()
        ref.child("USUARIO").child(idUser).child("houseId").setValue("0"){
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func cancelEye(){
      //  theReference.removeObserver(withHandle: theGreateye)
    }
}
