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
import CoreLocation

private let fireManager = FireBaseManager()

 protocol getAllHouseDelegate: class {
    func isActiveSession(landingPage:String )
}

class FireBaseManager : BaseManager{
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
    
    // MARK: Creacion casa
    static func  createHouse(model : ModelHouse ){
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
        ref.child("CASA").child(idHouse).setValue(BaseManager().prepareHouse(model: model, idHouse: idHouse)){
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
    
   static func inserBill(model: ModelBill,completion:@escaping (Bool) -> Void){
        let ref = Database.database().reference()
        model.billId = ref.childByAutoId().key
        ref.child("BILL").child(model.billId!).setValue(BaseManager().prepareBill(model:model)){
            (error:Error?, ref:DatabaseReference)in
            if let error = error{
                print("Data could not be saved: \(error).")
                completion(false)
            }else{
                print("Data saved successfully!")
                completion(true)
            }
        }
    }
      static func createBill(model: ModelBill,completion:@escaping (Bool) -> Void){
        inserBill(model: model){ (success) in
            if (success){
                
                let ref = Database.database().reference()
                let idHouse = HouseManager.sharedInstance.house?.idHouse
                let dictio = ["idBill":model.billId]
                ref.child("CASA").child(idHouse!).child("BILL").child(model.billId!).setValue(dictio){
                    (error:Error?, ref:DatabaseReference)in
                    if let error = error{
                        print("Data could not be saved: \(error).")
                    }else{
                        print("Data saved successfully!")
                        completion(true)
                    }
                }

            }
            
        }
    }
    static func createExpense(model: ModelExpense,completion:@escaping(Bool) -> Void){
        insertExpense(model: model) { (sucess) in
            if(sucess){
                let ref = Database.database().reference()
                let dictio = ["idExpense":model.idExpense]
                ref.child("BILL").child(model.idBill!).child("expense").child(model.idExpense!).setValue(dictio){
                    (error:Error?, ref:DatabaseReference)in
                    if let error = error{
                        print("Data could not be saved: \(error).")
                    }else{
                        print("Data saved successfully!")
                        completion(true)
                    }
                }
            }
        }
    }
    static func insertExpense(model: ModelExpense,completion:@escaping(Bool) -> Void){
        let ref = Database.database().reference()
         var expenseDictio = Dictionary<String, Any>()
        model.idExpense = ref.childByAutoId().key
        expenseDictio[model.idExpense!] = BaseManager().prepareExpense(model: model)
        ref.child("EXPENSE").child(model.idExpense!).setValue(BaseManager().prepareExpense(model: model)){
            (error:Error?, ref:DatabaseReference)in
            if let error = error{
                print("Data could not be saved: \(error).")
            }else{
                print("Data saved successfully!")
                completion(true)
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
    
      
    }
    
    
    
    

