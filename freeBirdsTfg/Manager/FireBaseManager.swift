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
    func isActiveSession(landingPage:String )
}

class FireBaseManager{
    //MARK: propiedades
   //TODO cargarse el delegado y poner un clousure!!
    public var userAuth: ((Bool) -> ())?
    weak var delegate: getAllHouseDelegate?
    var ref = DatabaseReference()
    var fullArrayHouse : ((Array<ModelHouse>) -> ())?
    
    //MARK: singleTon
    class var sharedInstance: FireBaseManager {
        
        return fireManager
    }
    
    //MARK: registro y session
    static func registerUser() {

    }
    
     func initSession() -> Bool{
        let sessionActive = false
       
        return sessionActive
    }
    //(completion: @escaping (Bool) -> ())
   func isSessionActive(){
    Auth.auth().addStateDidChangeListener {  (auth, user) in
        var landingPage = ""
        if user == nil
        {
            landingPage = "registro"
        }else{
            if UserDefaults.standard.object(forKey: BaseViewController.ALIAS) as? String != nil{
                if UserDefaults.standard.object(forKey: BaseViewController.IDHOUSE) as? String != "0"{
                    landingPage = "tiene casa"
                }else{
                    landingPage = "No casa"
                }
            }else{
                landingPage = "terminar Registro"
            }
        }
        self.delegate?.isActiveSession( landingPage:landingPage)
    }
    
    
    }
    
    static func createUser(model: ModelUser){
        let ref = Database.database().reference()
        let idUser = Auth.auth().currentUser?.uid
        let userDictio = ["alias":model.alias!,
                          "houseId":model.houseId,
                          "email":Auth.auth().currentUser?.email,
                          ]
        ref.child("USUARIO").child(idUser!).setValue(userDictio){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
        }
        }
    }
    
    
    static func getUserById(userID: String, completion:@escaping (ModelUser) -> Void){
        let ref = Database.database().reference()
        ref.child("USUARIO").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let user = ModelUser()
            user.idUser = userID
            user.alias = value?["alias"] as? String ?? ""
            user.email = value?["email"] as? String ?? ""
            user.houseId = value?["houseId"] as? String ?? ""
            completion(user)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    // MARK: Creacion casa
    static func  createHouse(model : ModelHouse ){
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
    let directionDictio = ["title": model.direction!.title!,
                "latitude":model.direction!.coordinate!.latitude,
                "longitude":model.direction!.coordinate!.longitude,
                "idDirection": ref.childByAutoId().key] as Dictionary
        
        var roomDictio = Dictionary<String, Any>()
        for item in model.listOfRoom! {
             let idRoom = ref.childByAutoId().key
            let dict = ["user":item.user! ,
                        "image":item.image as Any,
                        "PRICE":item.price!,
                         ] as Dictionary
            roomDictio[idRoom] = dict
            
        }
        var sectionDictio = Dictionary<String, Any>()
        if let secciones = model.section {
            for section in secciones {
                let idSection = ref.childByAutoId().key
                let dict = ["title":section.title! ,
                            "description":section.description!,
                            "image":section.image as Any,
                            ] as Dictionary
                sectionDictio[idSection] = dict
                
            }
        }
        var userDictio = Dictionary<String, Any>()
        for nameUser in model.user!{
            userDictio = ["userId":nameUser]
        }
        let dictioHouse=[
            "PRECIO": model.price ?? "0.0",
            "IDHOUSE": idHouse,
            "DESCRIPTION": model.completeDescription ?? "text",
            "DIRECTION" : directionDictio,
            "ROOMS" : roomDictio,
            "SECTIONS" : sectionDictio,
            "USER": userDictio
        ] as Dictionary
        ref.child("CASA").child(idHouse).setValue(dictioHouse){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                  UserDefaults.standard.set(idHouse, forKey: BaseViewController.IDHOUSE)
                let idUser = Auth.auth().currentUser?.uid
                let refUser = Database.database().reference()
                refUser.child("USUARIO").child(idUser!).updateChildValues(["houseId": idHouse])
            }
     
    }
    }
    
    func getHouse(completion: @escaping (Array<ModelHouse>) -> Void){
        var collectionHouse : Array<ModelHouse> = []
        let ref = Database.database().reference()
         ref.child("CASA").observeSingleEvent(of: DataEventType.value) { (shot) in
            for item in shot.children.allObjects as! [DataSnapshot]{
                 var fullHouse = ModelHouse()
                if let data = item.value as? NSDictionary {
                    fullHouse = self.parseHouse(dictioHouse: data)
                    collectionHouse.append(fullHouse)
                }
            }
            completion(collectionHouse)
        }
    }
    
    func getHouseUpdated(completion: @escaping (ModelHouse,Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").queryLimited(toLast: 1).observe(.childAdded, with:{ shot in
            var fullHouse = ModelHouse()
            if let data = shot.value as? NSDictionary {
                fullHouse = self.parseHouse(dictioHouse: data)
            }
            completion(fullHouse,true)
        })
        ref.child("CASA").observe(.childRemoved, with:{ shot in
            var fullHouse = ModelHouse()
            if let data = shot.value as? NSDictionary {
                fullHouse = self.parseHouse(dictioHouse: data)
            }
            completion(fullHouse,false)
        })
    }
   
    func parseHouse(dictioHouse:NSDictionary) -> ModelHouse{
        
        let fullHouse = ModelHouse()
            let keys = dictioHouse.allKeys as? Array<String>
            for key in keys!{
                switch key{
                case "PRICE":
                    let price = dictioHouse["PRICE"] as! String
                    fullHouse.price = price
                    break
                case "DESCRIPTION":
                    let completeDescription = dictioHouse["DESCRIPTION"] as! String
                    fullHouse.completeDescription = completeDescription
                    break
                case "IDHOUSE":
                    let idHouse = dictioHouse["IDHOUSE"] as! String
                    fullHouse.idHouse = idHouse
                    break
                case "DIRECTION":
                    let direction = self.getDirection(dictio: dictioHouse as! Dictionary<String, Any>)
                    fullHouse.direction = direction
                    break
                case "ROOMS":
                    let arrayRoom = self.getRoom(dictio: dictioHouse as! Dictionary<String, Any>)
                    fullHouse.listOfRoom = arrayRoom
                    break
                case "SECTIONS":
                    let arraySection = self.getSection(dictio: dictioHouse as! Dictionary<String, Any>)
                    fullHouse.section = arraySection
                    break
                default:
                    break
                }
            }
        
        return fullHouse;
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
    
    
    
    

