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



protocol refreshHouseData: class {
    func refresh()
}

class HouseManager : BaseManager{
    //gastos collection
     var user :  Array<ModelUser>?
     var house : ModelHouse?
     weak var delegate: refreshHouseData?
    
    static let sharedInstance = HouseManager()
    private override init (){}
    
    func setupData( completion:@escaping (Bool) -> Void){
      let idHouse = getUserDefault().houseId
        fillHouse(idHouse: idHouse ?? "default"){(finish) in
            if (finish){
                //
               // self.fillUser()
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
                    completedList.append(model)
                    count = count + 1
                    if(count == list.count){
                        completion(completedList)
                    }
                }
            }
        }else{
            completion(completedList)
        }
        
        
    }
     func getBillById(billId: String , completion:@escaping(ModelBill)-> Void){
        
        let ref = Database.database().reference()
        ref.child("BILL").child(billId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let model = ModelBill()
            model.billId = billId
            model.total = value?["total"] as? String ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.yyyy"
            let date = dateFormatter.date(from: value?["Date"] as? String ?? "")
            model.dateBill = date
            completion(model)
           
        }) { (error) in
            print(error.localizedDescription)
        }
    }
     func getListOfBillTest(idHouse: String){
        let refTest = Database.database().reference().child("CASA").child("-LdZnG42JSbWvQw_U3-v").child("BILL")
        //refTest.child("CASA").child("-LdZnG42JSbWvQw_U3-v").child("BILL")
        refTest.observeSingleEvent(of: .value) { (shot) in
            let que  = shot.value as? NSDictionary
            print("hola?")
        }
    }
    
    func fillUser(){
        //llamada recursiva para rellenar a todos los usuarios
    }
    
}
