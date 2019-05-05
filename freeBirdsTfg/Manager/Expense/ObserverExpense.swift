//
//  ObserverExpense.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol obeserverProtocol {
    func refreshExpense(model: ModelExpense)
}
class ObserverExpense: BaseManager{
    var delegate : obeserverProtocol?
    static let sharedInstance = ObserverExpense()
    private override init (){}
    
    func updatedExpense(idExpense: String){
     let ref = Database.database().reference()
        ref.child("EXPENSE").child(idExpense).observe(DataEventType.value, with: { (shot) in
            let value = shot.value as? NSDictionary
            guard let dictio = value, value != nil else{
                return
            }
         let model = self.getExpense(dictio:dictio,idExpense:idExpense)
            self.delegate?.refreshExpense(model: model)
        }) { (error) in
             print(error.localizedDescription)
        }
    }
    
   
}
/*
 refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
 let postDict = snapshot.value as? [String : AnyObject] ?? [:]
 // ...
 })
 
 */
