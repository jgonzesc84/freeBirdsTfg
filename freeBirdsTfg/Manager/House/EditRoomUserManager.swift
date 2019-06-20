//
//  EditRoomUserManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 11/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditRoomUserManager : BaseManager{
    
    func enterUserRoom(idRoom: String, user: ModelUser,completion:@escaping(Bool)-> Void){
        let ref = Database.database().reference()
         let rof = Database.database().reference()
        ref.child("CASA").child(user.houseId!).child("ROOMS").child(idRoom).child("user").setValue(user.idUser!) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
                rof.child("CASA").child(user.houseId!).child("ROOMS").child(idRoom).child("search").setValue(false){
                    (error:Error?, ref:DatabaseReference) in
                     completion(true)
            }
        }
    }
    }
    func exitUserRoom(idRoom: String, user: ModelUser,completion:@escaping(Bool)-> Void){
        let ref = Database.database().reference()
        ref.child("CASA").child(user.houseId!).child("ROOMS").child(idRoom).child("user").setValue(""){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
      completion(false)
            } else {
                  completion(true)
            }
        }
    }
    
    
    
}
