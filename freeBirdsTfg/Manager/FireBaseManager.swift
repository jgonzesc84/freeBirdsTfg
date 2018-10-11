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
import  CoreLocation

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
            ref.child("CASA").child(idHouse).child("ROOMS").child(idRoom).setValue(dict)
        }
        
    if let secciones = model.section {
            for section in secciones {
               let idSection = ref.childByAutoId().key
                let dict = ["title":section.title! ,
                            "description":section.description!,
                            "image":section.image as Any,
                            ] as Dictionary
                ref.child("CASA").child(idHouse).child("SECTIONS").child(idSection).setValue(dict)
            }
        } else {
        
        }
    }
    
    static func getHouse(){
         let ref = Database.database().reference()
            ref.child("CASA").observe(DataEventType.value, with:{ (snaphot) in
            for item in snaphot.children.allObjects as! [DataSnapshot]{
                let valores = item.value as?  [String:AnyObject]
                let testDirection = valores!["DIRECTION"] as? [String:AnyObject]
                let street = testDirection!["title"] as? String
                let latitud = testDirection!["latitude"] as? Double
                let longitude = testDirection!["longitude"] as? Double
                let location = CLLocationCoordinate2D(latitude: latitud!, longitude: longitude!)
                let direction = ModelDirection(title:street!, coordinate: location)
                
                let testSeccionList = valores!["SECTIONS"] as? [String:AnyObject]
                //testDirection?.keys
                
                let numberOfItems = testDirection?.count
                print(numberOfItems)
                
               
            }
    })
    }
    
    
    
    
}
