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
import SwiftyJSON

private let fireManager = FireBaseManager()

 let storage = Storage.storage().reference()

 protocol getAllHouseDelegate: class {
    func isActiveSession(landingPage:String )
}

class FireBaseManager : BaseManager{
    //MARK: propiedades
   //TODO cargarse el delegado y poner un clousure!!
    var firebaseAuthListener : AuthStateDidChangeListenerHandle?
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
    firebaseAuthListener = Auth.auth().addStateDidChangeListener {  (auth, user) in
        
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
        Auth.auth().removeStateDidChangeListener(self.firebaseAuthListener!)
    }
    
    
    }
    func requestAuthenticated(){
//       let authData = Auth.auth()
//        if(authData != nil){
//            print("que mierda pasa aqui?")
//        }
    }
    
    static func createUser(model: ModelUser){
        let ref = Database.database().reference()
        let idUser = Auth.auth().currentUser?.uid
        let storage = Storage.storage().reference()
        let imageName = UUID()
        let directory = storage.child("imagenes/\(imageName)")
        let userDictio = ["alias":model.alias!,
                          "houseId":model.houseId,
                          "email":Auth.auth().currentUser?.email,
                          "image": String(describing:directory)
                          ]
        ref.child("USUARIO").child(idUser!).setValue(userDictio){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
        }
            let resizedImaged = model.imageData?.resizeWithPercent(percentage: 0.1)
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            directory.putData(resizedImaged!.pngData()!, metadata: metadata) { (data, error) in
                if error == nil {
                    print("carga completada")
                }else{
                    if let error = error?.localizedDescription{
                        print("error al subir imágen firebase", error)
                    }
                }
            }
        }
    }
    static func editeUser(model: ModelUser){
        let ref = Database.database().reference()
        let storage = Storage.storage().reference()
        let imageName = UUID()
        let directory = storage.child("imagenes/\(imageName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let idUser = model.idUser
        let userDictio = ["alias":model.alias!,
                          "houseId":model.houseId,
                          "email":Auth.auth().currentUser?.email,
                          "image": String(describing:directory)
                          ]
        ref.child("USUARIO").child(idUser!).setValue(userDictio){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
        if let image = model.image{
            if image.count > 0{
                let imageDeleted = Storage.storage().reference(forURL: model.image!)
                imageDeleted.delete(completion: nil)
            }
        }
        HouseManager.sharedInstance.mainUser!.image = String(describing:directory)
       let resizedImaged = model.imageData?.resizeWithPercent(percentage: 0.1)
        directory.putData(resizedImaged!.pngData()!, metadata: metadata) { (data, error) in
            if error == nil {
                print("carga completada")
            }else{
                if let error = error?.localizedDescription{
                    print("error al subir imagen firebase", error)
                }
            }
        }
    }
    
    // MARK: Creacion casa
    static func  createHouse(model : ModelHouse,completion:@escaping(Bool)-> (Void) ){
    let ref = Database.database().reference()
    let idHouse = ref.childByAutoId().key
        model.idHouse = idHouse
        if let section = model.section{
            model.section = prepareListSectionWithImage(section)
        }
        if let rooms = model.listOfRoom{
            model.listOfRoom = prepareListRoomWithImage(rooms)
        }
        ref.child("CASA").child(idHouse).setValue(BaseManager().prepareHouse(model: model)){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
                  UserDefaults.standard.set(idHouse, forKey: BaseViewController.IDHOUSE)
                let idUser = Auth.auth().currentUser?.uid
                let refUser = Database.database().reference()
                refUser.child("USUARIO").child(idUser!).updateChildValues(["houseId": idHouse])
                completion(true)
            }
    }
        if let section = model.section{ //subir imagenes nuevas seccion
            uploadAllSectionImage(section)
        }
        if let rooms = model.listOfRoom{
            uploadAllRoomImage(rooms)
        }
    }
    static func  editHouse(model : ModelHouse,completion:@escaping(Bool)-> (Void) ){
        let ref = Database.database().reference()
        let idHouse = model.idHouse
        model.idHouse = idHouse
  //      var oldPath = [String]()
        if let section = model.section{
//            for item in section{
//                if let path = item.oldPath{
//                   oldPath.append(path)
//                }
//
//            }
            model.section = prepareListSectionWithImage(section)
        }
        if let rooms = model.listOfRoom{
            model.listOfRoom = prepareListRoomWithImage(rooms)
        }
        ref.child("CASA").child(idHouse!).setValue(BaseManager().prepareHouse(model: model)){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                completion(false)
            } else {
                completion(true)
            }
        }
        if let section = model.section{ //subir imagenes editadas seccion
            uploadAllSectionImage(section)
        }
        if let rooms = model.listOfRoom{
            uploadAllRoomImage(rooms)
        }
//        if (oldPath.count > 0){
//            for path in oldPath{
//                let imageDeleted = Storage.storage().reference(forURL: path)
//                imageDeleted.delete(completion: nil)
//            }
//
//        }
        
        
        ///WALLY
    }
    func getHouse(completion: @escaping (Array<ModelHouse>) -> Void){
        var collectionHouse : Array<ModelHouse> = []
        let ref = Database.database().reference()
        ref.child("CASA").queryOrdered(byChild: "SEARCHMATE").queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (shot) in
            let json = JSON(shot.value as Any)
            _ = json.dictionary?.compactMap{ json -> Void in
                var fullHouse = ModelHouse()
                let values = json.value
                 fullHouse = self.parseHouseJson(json: values)
                 collectionHouse.append(fullHouse)
            }
            completion(collectionHouse)
        }
     
    }
    
    func getHouseUpdated(completion: @escaping (ModelHouse,Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").queryOrdered(byChild: "SEARCHMATE").queryEqual(toValue: true).queryLimited(toLast: 1).observe(.childAdded, with:{ shot in
            var fullHouse = ModelHouse()
            let json = JSON(shot.value as Any)
            fullHouse = self.parseHouseJson(json: json)
            completion(fullHouse,true)
        })
        ref.child("CASA").queryOrdered(byChild: "SEARCHMATE").queryEqual(toValue: true).observe(.childRemoved, with:{ shot in
            var fullHouse = ModelHouse()
            let json = JSON(shot.value as Any)
            fullHouse = self.parseHouseJson(json: json)
            completion(fullHouse,false)
        })
//        ref.child("CASA").queryOrdered(byChild: "SEARCHMATE").queryEqual(toValue: true).queryLimited(toLast: 1).observe(.childChanged, with:{ shot in
//            var fullHouse = ModelHouse()
//            let json = JSON(shot.value as Any)
//            fullHouse = self.parseHouseJson(json: json)
//            completion(fullHouse,false)
//        })
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
      static func createBill(model: ModelBill,completion:@escaping (Bool,String) -> Void){
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
                        completion(true,model.billId!)
                    }
                }

            }
            
        }
    }
    static func createExpense(model: ModelExpense,completion:@escaping(Bool) -> Void){
        insertExpense(model: model) { (sucess) in
            if(sucess){
                let ref = Database.database().reference()
                var dictioInner = [String: String]()
                if let users =  model.users{
                    for user in users{
                        dictioInner[user.idUser!] = user.idUser
                    }
                }
                let dictio = ["idExpense":model.idExpense as Any,
                              "idUser":dictioInner
                ]
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
    
    static func editExpense(model: ModelExpense,completion:@escaping(Bool) -> Void){
                let ref = Database.database().reference()
                let dictio =  BaseManager().prepareExpense(model: model)
                ref.child("EXPENSE").child(model.idExpense!).setValue(dictio){
                    (error:Error?, ref:DatabaseReference)in
                    if let error = error{
                        print("Data could not be saved: \(error).")
                    }else{
                        print("Data saved successfully!")
                         let rof = Database.database().reference()
                        var dictioInner = [String: String]()
                        if let users =  model.users{
                            for user in users{
                                dictioInner[user.idUser!] = user.idUser
                            }
                        }
                        let dictioBill = ["idExpense":model.idExpense as Any,
                                      "idUser":dictioInner
                        ]
                        rof.child("BILL").child(model.idBill!).child("expense").child(model.idExpense!).setValue(dictioBill){
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
        ref.child("EXPENSE").child(model.idExpense!).setValue(BaseManager().prepareExpenseJson(model: model)){
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
            if let value = snapshot.value as? NSDictionary{
                var user = ModelUser()
                user = BaseManager().getUserModel(value, userID)
                completion(user)
            }else{
                completion(ModelUser())
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    static func getUserByIdIncomplete(userID: String, completion:@escaping (ModelUser) -> Void){
        let ref = Database.database().reference()
        ref.child("USUARIO").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                var user = ModelUser()
                user = BaseManager().getUserModel(value, userID)
                completion(user)
            }else{
                completion(ModelUser())
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
   static func prepareListSectionWithImage(_ list: [ModelHouseSection]) -> [ModelHouseSection]{
        var returnList = [ModelHouseSection]()
        for section in list{
            if (section.imageData != nil){
                section.image = giveDirectoryImage()
            }
            returnList.append(section)
        }
         return returnList
    }
    static func prepareListRoomWithImage(_ list: [ModelRoom]) -> [ModelRoom]{
        var returnList = [ModelRoom]()
        for room in list{
            if (room.imageData != nil){
                room.image = giveDirectoryImage()
            }
            returnList.append(room)
        }
        return returnList
    }
    
  static  func giveDirectoryImage()-> String{
        let storage = Storage.storage().reference()
        let imageName = UUID()
        let directory = storage.child("imagenes/\(imageName)")
        return String(describing:directory)
    }
    
    static func uploadAllSectionImage(_ list:[ModelHouseSection]){
        for section in list{
            if let path = section.image{
                if (path.count > 0 && section.imageData != nil){
                    uploadImage(path: path, image: section.imageData!,percentage:0.3)
                }
            }
        }
    }
    
    static func uploadAllRoomImage(_ list:[ModelRoom]){
        for room in list{
            if let path = room.image{
                if (path.count > 0 && room.imageData != nil){
                    uploadImage(path: path, image: room.imageData!, percentage: 1)
                }
            }
        }
    }
    
    static func uploadImage(path: String, image: UIImage, percentage:CGFloat){
        let storage = Storage.storage().reference()
        let lastString = path.split(separator: "/").last
        let directory = storage.child("imagenes/\(lastString ?? "")")
        let resizedImaged = image.resizeWithPercent(percentage: percentage)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        directory.putData(resizedImaged!.pngData()!, metadata: metadata) { (data, error) in
            if error == nil {
                print("carga completada")
            }else{
                if let error = error?.localizedDescription{
                    print("error al subir imagen firebase", error)
                }
            }
        }
    }
    /*
     if let image = model.image{
     if image.count > 0{
     let imageDeleted = Storage.storage().reference(forURL: model.image!)
     imageDeleted.delete(completion: nil)
     }
 */
    static func uploadImageEdited(path: String, image: UIImage, oldPath:String){
        let storage = Storage.storage().reference()
        let lastString = path.split(separator: "/").last
        let directory = storage.child("imagenes/\(lastString ?? "")")
      //  let resizedImaged = image.resizeWithPercent(percentage: 0.9)
        let testImage = image.resizeCI(size: CGSize(width: 400, height: 400))
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if oldPath.count > 0{
            let imageDeleted = Storage.storage().reference(forURL: oldPath)
            imageDeleted.delete(completion: nil)
        }
        directory.putData(testImage!.pngData()!, metadata: metadata) { (data, error) in
            if error == nil {
                print("carga completada")
            }else{
                if let error = error?.localizedDescription{
                    print("error al subir imagen firebase", error)
                }
            }
        }
    }
    
    }
    
    
    
    

