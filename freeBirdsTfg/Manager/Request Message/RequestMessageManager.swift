//
//  RequestMessageManager.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RequestMessageManager{
    let factory = RequestMessageFactory()
    /*
     static func insertExpense(model: ModelExpense,completion:@escaping(Bool) -> Void){
     let ref = Database.database().reference()
     var expenseDictio = Dictionary<String, Any>()
     model.idExpense = ref.childByAutoId().key
     expenseDictio[model.idExpense!] = BaseManager().prepareExpense(model: model)
     ref.child("EXPENSE").child(model.idExpense!).setValue(BaseManager().prepareExpense(model: model)){
     (error:Error?, ref:DatabaseReference)in
     if let error = error{
     print("Data could not be saved: \(error).")
     }else{
     print("Data saved successfully!")
     completion(true)
     }
     }
     }
     
 
 */
   
    func insertRequest(_ model: ModelRequestHouse ,completion:@escaping(Bool) -> Void){
        let ref = Database.database().reference()
        model.idRequest = ref.childByAutoId().key
        ref.child("SOLICITUD").child(model.idRequest!).setValue(factory.prepareRequestHouse(model)){
            (error:Error?, ref:DatabaseReference)in
            if let error = error{
              
            }else{
               
                completion(true)
            }
        }
    }

}
