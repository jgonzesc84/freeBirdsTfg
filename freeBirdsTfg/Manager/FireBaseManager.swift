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
    
    static func  createHouse(model : ModelHouse){
    
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
   
    ref.child("CASA").child(idHouse).child("price").setValue(model.price)
        
    let dict = ["title": model.direction!.title!,
                "latitude":model.direction!.coordinate!.latitude,
                "longitude":model.direction!.coordinate!.longitude,
                "idDirection": ref.childByAutoId().key] as Dictionary
        
        ref.child("CASA").child(idHouse).child("DIRECTION").setValue(dict)
       
        for item in model.listOfRoom! {
             let idRoom = ref.childByAutoId().key
            let dict = ["user":item.user! ,
                        "image":item.image as Any,
                        "price":item.price!,
                         ] as Dictionary
            ref.child("CASA").child(idHouse).child("ROOMLIST").child("ROOM").child(idRoom).setValue(dict)
        }
        
    if let secciones = model.section {
            for section in secciones {
               let idSection = ref.childByAutoId().key
                let dict = ["title":section.title! ,
                            "description":section.description!,
                            "image":section.image as Any,
                            ] as Dictionary
                ref.child("CASA").child(idHouse).child("SECTIONLIST").child("SECTION").child(idSection).setValue(dict)
            }
        } else {
        
        }
        
     

        
    }
    
    
    
    
}
