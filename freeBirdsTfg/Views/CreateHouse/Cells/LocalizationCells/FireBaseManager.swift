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
    
    init(){
        ref = Database.database().reference()
    }
    
    func  createHouse(model : ModelHouse){
    
    ref = Database.database().reference()
    let id = ref.childByAutoId().key
    ref.child("CASA").child(id).child("price").setValue(model.price)

        
    }
    
    
}
