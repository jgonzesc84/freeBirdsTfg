//
//  FireBaseManager.swift
//  freeBirdsTfg
//
//  Created by Javier on 26/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
private let fireManager = FireBaseManager()

class FireBaseManager{

    class var sharedInstance: FireBaseManager {
        return fireManager
    }
    
      var ref = DatabaseReference()
    
   /* init(){
        ref = Database.database().reference()
    }*/
    
    static func  createHouse(model : ModelHouse){
    
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
    let idDirection = ref.childByAutoId().key
        
    ref.child("CASA").child(idHouse).child("price").setValue(model.price)
    ref.child("CASA").child(idHouse).child("idDirection").setValue(idDirection)
        
    ref.child("DIRECTION").child(idDirection).child("title").setValue(model.direction?.title)
    ref.child("DIRECTION").child(idDirection).child("latitude").setValue(model.direction?.coordinate?.latitude)
    ref.child("DIRECTION").child(idDirection).child("longitude").setValue(model.direction?.coordinate?.longitude)
    
        
        for room in model.listOfRoom! {
              let idRoom = ref.childByAutoId().key
             ref.child("ROOM").child(idRoom).child("price").setValue(room.price)
             ref.child("ROOM").child(idRoom).child("user").setValue(room.user)
             ref.child("ROOM").child(idRoom).child("image").setValue(room.image)
             ref.child("ROOM").child(idRoom).child("idHouse").setValue(idHouse)
        }
        
        for section in model.section! {
            let idsection = ref.childByAutoId().key
            ref.child("SECTION").child(idsection).child("title").setValue(section.title)
            ref.child("SECTION").child(idsection).child("description").setValue(section.description)
            ref.child("SECTION").child(idsection).child("image").setValue(section.image)
            ref.child("SECTION").child(idsection).child("idHouse").setValue(idHouse)
        }

        
    }
    
    
    
    
}
