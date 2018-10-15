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

 protocol getAllHouseDelegate: class {
     func getHouseArray(array: Array<ModelHouse>?)
     func getNewHouse(model: ModelHouse)
}

class FireBaseManager{
    
    
    var fullArrayHouse : ((Array<ModelHouse>) -> ())?
    weak var delegate: getAllHouseDelegate?
    
    class var sharedInstance: FireBaseManager {
      
        return fireManager
    }
    
var ref = DatabaseReference()
    
    static func  createHouse(model : ModelHouse){
    
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
   
    ref.child("CASA").child(idHouse).child("PRICE").setValue(model.price)
     ref.child("CASA").child(idHouse).child("IDHOUSE").setValue(idHouse)
        
        if let secciones = model.section {
            var dictioTotal = Dictionary<String, Any>()
            for section in secciones {
                let idSection = ref.childByAutoId().key
                let dict = ["title":section.title! ,
                            "description":section.description!,
                            "image":section.image as Any,
                            ] as Dictionary
                dictioTotal[idSection] = dict
                
            }
            ref.child("CASA").child(idHouse).child("SECTIONS").setValue(dictioTotal)
        } else {
            
        }
    let dict = ["title": model.direction!.title!,
                "latitude":model.direction!.coordinate!.latitude,
                "longitude":model.direction!.coordinate!.longitude,
                "idDirection": ref.childByAutoId().key] as Dictionary
        
        ref.child("CASA").child(idHouse).child("DIRECTION").setValue(dict)
        var dictioTotal = Dictionary<String, Any>()
        for item in model.listOfRoom! {
             let idRoom = ref.childByAutoId().key
            let dict = ["user":item.user! ,
                        "image":item.image as Any,
                        "PRICE":item.price!,
                         ] as Dictionary
            dictioTotal[idRoom] = dict
            
        }
        ref.child("CASA").child(idHouse).child("ROOMS").setValue(dictioTotal)
        
    }
    
     func getHouse(){
        var collectionHouse : Array<ModelHouse> = []
        
        let ref = Database.database().reference()
        var cont = 0
         ref.child("CASA").observeSingleEvent(of: DataEventType.value) { (shot) in
             let totalHouse = shot.childrenCount
            if (totalHouse != 0){
            for item in shot.children.allObjects as! [DataSnapshot]{
                let valores = item.value as?  [String:AnyObject]
                let direction = self.getDirection(dictio: valores!)
                let arraySection = self.getSection(dictio: valores!)
                let arrayRoom = self.getRoom(dictio: valores!)
                let idHouse = valores!["IDHOUSE"] as? String
                let price = valores!["PRICE"] as? String
                let fullHouse = ModelHouse(price: price, section: arraySection, listOfRoom: arrayRoom, direction: direction)
                fullHouse.idHouse = idHouse
                collectionHouse.append(fullHouse)
                cont += 1
                if(cont == totalHouse){
                    self.delegate?.getHouseArray(array:  collectionHouse)
                }
            }
            }else{
                  self.delegate?.getHouseArray(array:  collectionHouse)
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
            let price = sectionDictio!["PRICE"] as? String
            let roomModel = ModelRoom()
            roomModel.user = user!
            roomModel.price = price!
           
            arrayRoom.append(roomModel)
        }
        return arrayRoom
    }
   /* func getRoomUpdate(dictio : Dictionary <String, Any>) -> ( Dictionary <String, Any>){
        let testRoomList = dictio["ROOMS"] as? [String:AnyObject]
        let dictioRoom = testRoomList?.keys
        var dictio = Dictionary <String , Any>()
        let componentRoom = Array(dictioRoom!)
        for key in componentRoom{
            let sectionDictio = testRoomList![key]
            let user = sectionDictio!["user"] as? String
            let price = sectionDictio!["PRICE"] as? String
            let freeRooms = sectionDictio!["FreeRooms"] as? String
            let roomModel = ModelRoom()
            roomModel.user = user!
            roomModel.price = price!
            dictio["model"] = roomModel
            dictio["order"] = freeRooms
            
        }
        return dictio
    }*/
    
    
    /*
     dictio["model"] = roomModel
     dictio["order"] = freeRooms
     let freeRooms = sectionDictio!["FreeRooms "] as? String
     //et fullNameArr = fullName.components(separatedBy: " ")
     /* let splitArray = freeRooms?.components(separatedBy:"-")
     let order = splitArray?[0]
     let totalRoom = splitArray?[1]*/
 
 */
    func getHouseUpdated(completion: @escaping (Bool) -> ()){
          let ref = Database.database().reference()
        var makeHouse = true
        var directionOk = false
        var roomOk = false
        var price = ""
        var idHouse = ""
        var direction = ModelDirection()
         var arrayRoom = Array<ModelRoom> ()
        var arraySection = Array<ModelHouseSection> ()
          ref.child("CASA").queryLimited(toLast: 1).observe(DataEventType.value, with: { shot in
            if let data = shot.value as? NSDictionary {
                let firstLevel = data as?  [String:AnyObject]
                let dictioKey = firstLevel?.keys
                if let key = dictioKey{
                    var oneKey = Array(key)
                    let valores = firstLevel![oneKey[0]]
                    let keys = valores?.allKeys as? Array<String>
                    for key in keys!{
                        switch key{
                        case "PRICE":
                            price = valores!["PRICE"] as! String
                            break
                        case "IDHOUSE":
                            idHouse = valores!["IDHOUSE"] as! String
                            break
                        case "DIRECTION":
                            direction = self.getDirection(dictio: valores as! Dictionary<String, Any>)
                            directionOk = true
                            break
                        case "ROOMS":
                           arrayRoom = self.getRoom(dictio: valores! as! Dictionary<String, Any>)
                           roomOk = true
                            break
                        case "SECTIONS":
                            arraySection = self.getSection(dictio: valores as! Dictionary<String, Any>)
                            break
                        default:
                            makeHouse = false
                            break
                        }
                    }
                    if(directionOk && roomOk && makeHouse){
                        let fullHouse = ModelHouse(price: price, section: arraySection, listOfRoom: arrayRoom, direction: direction)
                        fullHouse.idHouse = idHouse
                        self.delegate?.getNewHouse(model: fullHouse)
                        makeHouse = true
                        roomOk = false
                        directionOk = false
                    }
                }
            }
        
            completion(true)
        })
    }
  
        
      
    }
    
    
    
    

