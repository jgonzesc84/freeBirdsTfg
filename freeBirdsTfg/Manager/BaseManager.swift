//
//  BaseManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 24/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import  CoreLocation
import FirebaseDatabase
import SwiftyJSON

class BaseManager{
    
    //////////////DEFAULT////////////////////
    func getUserDefault() -> ModelUser{
        let user = ModelUser()
        user.idUser = UserDefaults.standard.object(forKey: BaseViewController.IDUSER) as? String
        user.alias = UserDefaults.standard.object(forKey: BaseViewController.ALIAS) as? String
        user.email = UserDefaults.standard.object(forKey: BaseViewController.EMAIL) as? String
        if  (UserDefaults.standard.object(forKey: BaseViewController.IDHOUSE)) as? String != nil{
            user.houseId = UserDefaults.standard.object(forKey: BaseViewController.IDHOUSE) as? String
        }
        return user
    }
    func userId() -> String{
        return self.getUserDefault().idUser ?? ""
    }
    func houseId()-> String{
        return self.getUserDefault().houseId!
    }
    
    func saveUserDefault(model: ModelUser){
        let userDefault = UserDefaults.standard
        userDefault.set(model.idUser, forKey: BaseViewController.IDUSER)
        userDefault.set(model.houseId, forKey:BaseViewController.IDHOUSE)
        userDefault.set(model.alias, forKey:BaseViewController.ALIAS)
        userDefault.set(model.email, forKey:BaseViewController.EMAIL)
    }
    
    
    //////////////////HOUSE///////////////////
    func parseHouseJson(json: JSON)-> ModelHouse{
        let house = ModelHouse()
       // house.price = json["Price"].stringValue
        house.description = json["DESCRIPTION"].stringValue
        house.idHouse = json["IDHOUSE"].stringValue
        house.direction = getDirectionJson(json:json["DIRECTION"])
        house.listOfRoom = getRoomJson(json: json["ROOMS"])
        if let _ = json["SECTIONS"].dictionary{
           house.section = getSectionJson(json:json["SECTIONS"])
        }else{
            house.section = [ModelHouseSection]()
        }
       house.user = getUserJson(json: json["USER"])
        house.searchMate = json["SEARCHMATE"].bool
        if  let _ = json["BILL"].dictionary{
            house.listOfBill = getBillJson(json: json["BILL"])
        }else{
             house.listOfBill = [ModelBill]()
        }
        return house
    }
    
    //////////////GETTER HOUSE////////////////
    func getDirectionJson(json :JSON) -> (ModelDirection){
        let direction = ModelDirection()
        direction.title = json["title"].stringValue
        direction.coordinate = CLLocationCoordinate2D(latitude: json["latitude"].double!, longitude: json["longitude"].double!)
        return direction
    }
    func getSectionJson(json: JSON) -> Array<ModelHouseSection>{
       var sections = [ModelHouseSection]()
         _ = json.dictionary?.compactMap { json -> Void in
            let section = ModelHouseSection()
            let values = json.value
            section.title = values["title"].stringValue
            section.description = values ["description"].string
            sections.append(section)
        }
        
        return sections
        
    }
    func getRoomJson(json: JSON) -> Array<ModelRoom>{
        var rooms = [ModelRoom]()
        _ = json.dictionary?.compactMap{ json -> Void in
            let room = ModelRoom()
            room.idRoom = json.key
            let values = json.value
            room.price = values["PRICE"].string
            room.search = values["search"].bool
            if let userId = values["user"].string{
                let user = ModelUser()
                user.idUser = userId
                room.user = user
            }
            rooms.append(room)
        }
        return rooms
    }
    
    func getUserJson(json:JSON)-> Array<ModelUser>{
        var users = [ModelUser]()
        _ = json.dictionary?.compactMap{ json -> Void in
            let values = json.value
            if let userId = values["idUser"].string {
                if (userId.count > 0){
                    let user = ModelUser()
                    user.idUser = userId
                    users.append(user)
                }
            }
        }
        return users
    }
    
    func getBillJson(json:JSON) -> Array<ModelBill>{
       var bills = [ModelBill]()
        _ = json.dictionary?.compactMap{ json -> Void in
            let idBill = json.key
            let bill = ModelBill()
            bill.billId = idBill
            bills.append(bill)
        }
        return bills
        
    }
    
    func getDirection(dictio: Dictionary<String, Any>) -> (ModelDirection){
        var value = Dictionary <String, Any>()
        if let testDirection = dictio["DIRECTION"] as? [String:AnyObject]{
            value = testDirection
        }else{
            value = dictio
        }
        let street = value["title"] as? String
        let latitud = value["latitude"] as? Double
        let longitude = value["longitude"] as? Double
        let location = CLLocationCoordinate2D(latitude: latitud!, longitude: longitude!)
        let direction = ModelDirection(title:street!, coordinate: location)
        return direction
    }

     func prepareHouse(model : ModelHouse)-> (Dictionary<String, Any>){
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
        }
        if let rooms = model.listOfRoom{
            dictio["ROOMS"] = prepareRoom(rooms:rooms)
        }
        if let sections = model.section{
            dictio["SECTIONS"] = prepareSection(sections: sections)
        }
        if let user = model.user{
            dictio["USER"] = prepareUser(users: user)
        }
        if let bill = model.listOfBill{
            dictio["BILL"] = prepareListOfBill(list: bill)
        }
        return dictio
    }
    
    func prepareHouseBill(model : ModelHouse)-> (Dictionary<String, Any>){
    
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
        }
        return dictio
        
    }
    
    func prepareDirection(model : ModelDirection,  new: Bool) -> (Dictionary<String, Any>){
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
        }
        return dictio
    }
    
     func prepareRoom(rooms : [ModelRoom]) -> (Dictionary<String, Any>){
            var dictio = [String: Any]()
            let jsonEncoder = JSONEncoder()
            for room in rooms{
                let jsonData = try! jsonEncoder.encode(room)
                if var dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                     let idRoom = Database.database().reference().childByAutoId().key
                    if let userRoom = room.user{
                             dictionary["user"] = userRoom.idUser
                    }
                    dictio[idRoom] = dictionary
                }
            }
       
        return dictio
        
    }
    
     func prepareSection(sections : [ModelHouseSection]) -> (Dictionary<String, Any>){
        var dictio = [String: Any]()
       
            let jsonEncoder = JSONEncoder()
            for section in sections{
                let jsonData = try! jsonEncoder.encode(section)
                if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    let idSection = Database.database().reference().childByAutoId().key
                    dictio[idSection] = dictionary
                }
            }
        
        return dictio
    }
    func prepareUserId(users : [ModelUser]) -> (Dictionary<String, Any>){
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        for user in users{
            var userOnlyId  = ModelUser()
            userOnlyId.idUser = user.idUser
            let jsonData = try! jsonEncoder.encode(userOnlyId)
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                dictio[user.idUser ?? ""] = dictionary
            }
        }
        
        return dictio
    }
    func prepareUser(users : [ModelUser]) -> (Dictionary<String, Any>){
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        for user in users{
            let jsonData = try! jsonEncoder.encode(user)
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                dictio[user.idUser ?? ""] = dictionary
            }
        }
        
        return dictio
    }
    
    func preparePayment(payments: [ModelPayment]) -> (Dictionary<String, Any>){
        let jsonEncoder = JSONEncoder()
        var dictio = [String: Any]()
        for pay in payments{
            let jsonData = try! jsonEncoder.encode(pay)
            if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                let idPayment = pay.idPayment
                dictio[idPayment ?? ""] = dictionary
            }
        }
        
        return dictio
    }
    
    
    /////////////////USER////////
    
    func getUser(dictio : Dictionary <String, Any>) -> (Array<ModelUser>){
        let testUserList = dictio["USER"] as? [String:AnyObject]
        var arrayUser : Array<ModelUser> = []
        let dictioUser = testUserList?.keys
        let componentUser = Array(dictioUser!)
        arrayUser.append(getUserDefault())
        for key in componentUser{
            let userId = key
            if (userId != getUserDefault().idUser && userId.count > 0){
                let user = ModelUser()
                user.idUser = userId
                arrayUser.append(user)
            }
        }
        return arrayUser
    }

   
    
    func prepareUserNoHouse(idUser : String) -> (Dictionary<String, Any>){
        var userDictio = Dictionary<String, Any>()
       
            userDictio = ["idUser":idUser]
        
        return userDictio
    }

    func getUserModel(_ dictio : NSDictionary, _ idUser: String) ->(ModelUser){
        let model = ModelUser()
        model.idUser = idUser
        model.alias = dictio["alias"] as? String ?? ""
        model.email = dictio["email"] as? String ?? ""
        model.houseId = dictio["houseId"] as? String ?? ""
        if let valueRequest = dictio["solicitudes"] as? NSDictionary {
            let listId = valueRequest.allKeys
            model.request = convertRequestMessageColection(listId as! Array<String>)
            
        }
        return model
    }
    
    func convertRequestMessageColection(_ list :Array<String>) -> (Array<ModelRequestHouse>){
        var collectionRequest = Array <ModelRequestHouse>()
        if (list.count > 0){
            for item in list{
                let model = ModelRequestHouse()
                model.idRequest = item
                collectionRequest.append(model)
            }
        }
        return collectionRequest
    }
    
    /////////////////BILL///////////////
    
    ////GET/////
    func getBill(dictio : Dictionary <String, Any>) -> (Array<ModelBill>){
        var arrayBill : Array<ModelBill> = []
        let testBillList = dictio["BILL"] as? [String:AnyObject]
        if testBillList != nil {
            let listBill = Array(testBillList!.keys)
            for key in listBill{
                
                let bill = ModelBill()
                bill.billId = key
                arrayBill.append(bill)
            }
        }
        return arrayBill
    }
    //////SET////
    func prepareBill(model: ModelBill) -> (Dictionary<String, Any>){
        
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
        }
        return dictio
    }
    
    func prepareListOfBill(list : Array<ModelBill>) -> (Dictionary<String,Any>){
        var userDictio = Dictionary<String, Any>()
        var innerDictio = Dictionary<String, Any>()
        for model in list{
            innerDictio = ["userId":model.billId!]
            userDictio[model.billId!] = innerDictio
        }
        return userDictio
    }
    
    func prepareExpenseJson(model: ModelExpense) -> [String : Any]{
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
//            if let user = model.users{
//                dictio["users"] = prepareUserId(users: user)
//            }
            if let payment = model.payment{
                dictio["payment"] = preparePayment(payments: payment)
            }
        }
        return dictio
        
    }
    func prepareExpense(model: ModelExpense) -> (Dictionary<String,Any>){
        var dictio = [String: Any]()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(model)
        if let dictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            dictio = dictionary
//            if let user = model.users{
//                dictio["users"] = prepareUserId(users: user)
//            }
            if let payment = model.payment{
                dictio["payment"] = preparePayment(payments: payment)
            }
        }
        return dictio
    }
    
    ///GETTER//////
    func getExpense(dictio: NSDictionary,idExpense: String) -> (ModelExpense){
        let model = ModelExpense()
        model.idExpense = idExpense
        model.name = dictio["name"] as? String ?? ""
        model.quantify = dictio["quantify"] as? Double ?? 0.0
        model.selection = dictio["selection"] as? Bool
        model.color = dictio["color"] as? String ?? ""
        model.ico = dictio["ico"] as? String ?? ""
        model.idBill = dictio["idBill"] as? String ?? ""
        //
        //model.users = dictio["users"] as? Array
        model.idUser = dictio["users"] as? String ?? ""
        //
        print("HE SE HA MODIFOCADO ALGO")
        return model
    }
    
    func getListOfExpense(dictio: Dictionary <String, Any>) -> (Array<ModelExpense>){
        var arrayModel : Array<ModelExpense> = []
        let keys = dictio.keys
        for item in keys{
            
            let model = ModelExpense()
           let test = dictio[item] as? [String:AnyObject]
            model.idExpense = test!["idExpense"] as? String ?? ""
            model.idBill = test!["idUser"] as? String ?? ""
            arrayModel.append(model)
        }
        return arrayModel
    }
    
   
    
   //
    func fillRoomWithuUser( rooms: Array<ModelRoom>, users: Array<ModelUser>) -> Array<ModelRoom>{
        for room in rooms{
            if (room.user?.idUser != nil){
                for user in users{
                    if(room.user?.idUser == user.idUser){
                        room.user = user
                    }
                }
            }
           
        }
        return rooms
    }

    func parseUserOnRoom(_ model:ModelHouse) -> Array<ModelRoom>{
        if var rooms = model.listOfRoom, model.listOfRoom != nil{
            if let user = model.user, model.user != nil{
                for room in rooms{
                    let idUser = room.user?.idUser
                    if(idUser != ""){
                        room.user = user.first(where:{$0.idUser == idUser})
                        if let index = rooms.firstIndex(where: { $0.user!.idUser == idUser } ){
                            rooms.insert(room, at: index)
                          }
                    }
                }
            return rooms
            }
        }else{
          return  model.listOfRoom!
        }
        return model.listOfRoom!
    }

}
