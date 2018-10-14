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
    let dict = ["title": model.direction!.title!,
                "latitude":model.direction!.coordinate!.latitude,
                "longitude":model.direction!.coordinate!.longitude,
                "idDirection": ref.childByAutoId().key] as Dictionary
        
        ref.child("CASA").child(idHouse).child("DIRECTION").setValue(dict)
       
        for item in model.listOfRoom! {
             let idRoom = ref.childByAutoId().key
            let dict = ["user":item.user! ,
                        "image":item.image as Any,
                        "PRICE":item.price!,
                         ] as Dictionary
            ref.child("CASA").child(idHouse).child("ROOMS").child(idRoom).setValue(dict)
        }
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
    
    
    func updateHouseMap(){
       let ref = Database.database().reference()
        
        ref.child("CASA").queryLimited(toLast: 1).observe(DataEventType.value, with: { (shot) in
            /**
             FireBase
             problema 1: tra el último nodo el que ya esta no metrelo
             problema 2: esta atento a cualquier cambio en el último nodo y como no se hace la inserción  del objeto
             casa con todos sus child a la vez solo uno por uno, cuando se modifica algún child baja a ese child sin bajar los demás, pues es
             el primero que se modifica. Por ahora se usa el swicth
             problema 3: No se puede llamar al delegado apra que cree la anotación si no  estan todos los campos bajados de la casa por los flag
             problema 4: repensar esto `ara el modo edición y eliminación 
             /////////
             revisión mira de crear el objeto casa de golpe si se puede, Entender mejor Firebase para hacer las peticiones justas restructurar base de datos (posible).
             **/
            var makeHouse = true
            var directionOk = false
            var roomOk = false
            var price = ""
            var idHouse = ""
            var direction = ModelDirection()
            var arraySection = Array<ModelHouseSection> ()
            var arrayRoom = Array<ModelRoom>()
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
                    }
                }
            }
        }) { (Error) in
            
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
        
    
        
      
    }
    
    
    
    

