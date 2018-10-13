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

protocol testDelegate: class {
    func getHouseArray(array: Array<ModelHouse>?)
}

class FireBaseManager{
    
    
    var fullArrayHouse : ((Array<ModelHouse>) -> ())?
    weak var delegate: testDelegate?
    
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
    
     func getHouse(){
        var collectionHouse : Array<ModelHouse> = []
        
        let ref = Database.database().reference()
        var cont = 0
        ref.child("CASA").observeSingleEvent(of: DataEventType.value) { (shot) in
             let totalHouse = shot.childrenCount
            for item in shot.children.allObjects as! [DataSnapshot]{
                let valores = item.value as?  [String:AnyObject]
                let direction = self.getDirection(dictio: valores!)
                let arraySection = self.getSection(dictio: valores!)
                let arrayRoom = self.getRoom(dictio: valores!)
                let price = valores!["price"] as? String
                let fullHouse = ModelHouse(price: price, section: arraySection, listOfRoom: arrayRoom, direction: direction)
                collectionHouse.append(fullHouse)
                cont += 1
                if(cont == totalHouse){
                    self.delegate?.getHouseArray(array:  collectionHouse)
                }
            }
        }
    }
    
    func getDirection(dictio: Dictionary<String, Any>) -> (ModelDirection){
        let testDirection = dictio["DIRECTION"] as? [String:AnyObject]
        let street = testDirection!["title"] as? String
        let latitud = testDirection!["latitude"] as? Double
        let longitude = testDirection!["longitude"] as? Double
        let location = CLLocationCoordinate2D(latitude: latitud!, longitude: longitude!)
        let direction = ModelDirection(title:street!, coordinate: location)
        return direction
    }
    
    func getSection(dictio : Dictionary <String, Any>) -> (Array<ModelHouseSection>){
        let testSeccionList = dictio["SECTIONS"] as? [String:AnyObject]
        var arraySection : Array<ModelHouseSection> = []
        let dictio = testSeccionList?.keys
        if let somethingDictio = dictio{
            let componentArray = Array(somethingDictio)
            for key in componentArray{
                let sectionDictio = testSeccionList![key]
                let titleSection = sectionDictio!["title"] as? String
                let descriptionSection = sectionDictio!["description"] as? String
                let sectionModel = ModelHouseSection()
                sectionModel.title = titleSection!
                sectionModel.description = descriptionSection!
                arraySection.append(sectionModel)
            }
        }
        return arraySection
    }
    func getRoom(dictio : Dictionary <String, Any>) -> (Array<ModelRoom>){
        let testRoomList = dictio["ROOMS"] as? [String:AnyObject]
        var arrayRoom : Array<ModelRoom> = []
        let dictioRoom = testRoomList?.keys
        let componentRoom = Array(dictioRoom!)
        for key in componentRoom{
            let sectionDictio = testRoomList![key]
            let user = sectionDictio!["user"] as? String
            let price = sectionDictio!["price"] as? String
            let roomModel = ModelRoom()
            roomModel.user = user!
            roomModel.price = price!
            arrayRoom.append(roomModel)
        }
        return arrayRoom
    }
        
    
        
      
    }
    
    
    
    

