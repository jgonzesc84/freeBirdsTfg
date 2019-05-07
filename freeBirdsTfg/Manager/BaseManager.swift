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
    
    func saveUserDefault(model: ModelUser){
        let userDefault = UserDefaults.standard
        userDefault.set(model.idUser, forKey: BaseViewController.IDUSER)
        userDefault.set(model.houseId, forKey:BaseViewController.IDHOUSE)
        userDefault.set(model.alias, forKey:BaseViewController.ALIAS)
        userDefault.set(model.email, forKey:BaseViewController.EMAIL)
    }
    
    
    //////////////////HOUSE///////////////////
    
    //////SETTER HOUSE//////////
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
            case "USER":
                let arrayUser = self.getUser(dictio: dictioHouse as! Dictionary<String, Any>)
                fullHouse.user = arrayUser
                break
            case "SEARCHMATE":
                let searchMate = dictioHouse["SEARCHMATE"] as! Bool
                fullHouse.searchMate = searchMate
                break
            case "BILL":
                let arrayBill = self.getBill(dictio: dictioHouse as! Dictionary<String, Any>)
                fullHouse.listOfBill = arrayBill
                break
            default:
                break
            }
        }
        
        return fullHouse;
    }
    
    //////////////GETTER HOUSE////////////////
    
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
            let search = sectionDictio!["search"] as? Bool
            let roomModel = ModelRoom()
            roomModel.user = user!
            roomModel.price = price!
            roomModel.search = search
            arrayRoom.append(roomModel)
        }
        return arrayRoom
    }
    
   
    
    
     func prepareHouse(model : ModelHouse, idHouse: String)-> (Dictionary<String, Any>){
        let dictioHouse=[
            "PRECIO": model.price ?? "0.0",
            "IDHOUSE": idHouse,
            "DESCRIPTION": model.completeDescription ?? "text",
            "DIRECTION" : prepareDirection(model: model),
            "ROOMS" : prepareRoom(model: model),
            "SECTIONS" : prepareSection(model: model),
            "USER": prepareUser(model: model),
            "SEARCHMATE" : model.searchMate!,
            "BILL" : ""
            ] as Dictionary
        return dictioHouse
    }
    
     func prepareDirection(model : ModelHouse) -> (Dictionary<String, Any>){
        let directionDictio = ["title": model.direction!.title!,
                               "latitude":model.direction!.coordinate!.latitude,
                               "longitude":model.direction!.coordinate!.longitude,
                               "idDirection":Database.database().reference().childByAutoId().key ] as Dictionary
        return directionDictio
    }
    
     func prepareRoom(model : ModelHouse) -> (Dictionary<String, Any>){
         var roomDictio = Dictionary<String, Any>()
        for item in model.listOfRoom! {
            let idRoom = Database.database().reference().childByAutoId().key
            let dict = ["user":item.user! ,
                        "image":item.image as Any,
                        "PRICE":item.price!,
                        "search": item.search!
                        ] as Dictionary
            roomDictio[idRoom] = dict
            
    }
        return roomDictio
    }
    
     func prepareSection(model : ModelHouse) -> (Dictionary<String, Any>){
        var sectionDictio = Dictionary<String, Any>()
        if let secciones = model.section {
            for section in secciones {
                let idSection = Database.database().reference().childByAutoId().key
                let dict = ["title":section.title! ,
                            "description":section.description!,
                            "image":section.image as Any,
                            ] as Dictionary
                sectionDictio[idSection] = dict
                
            }
    }
        return sectionDictio
    }
    
    
    
    /////////////////USER////////
    
    func getUser(dictio : Dictionary <String, Any>) -> (Array<ModelUser>){
        let testUserList = dictio["USER"] as? [String:AnyObject]
        var arrayUser : Array<ModelUser> = []
        let dictioUser = testUserList?.keys
        let componentUser = Array(dictioUser!)
        arrayUser.append(getUserDefault())
        for key in componentUser{
            let userId = testUserList![key] as? String
            if (userId != getUserDefault().idUser){
                let user = ModelUser()
                user.idUser = userId
                arrayUser.append(user)
            }
        }
        return arrayUser
    }
    
    func prepareUser(model : ModelHouse) -> (Dictionary<String, Any>){
        var userDictio = Dictionary<String, Any>()
        for nameUser in model.user!{
            userDictio = ["userId":nameUser.idUser!]
        }
        return userDictio
    }
    
    func getUserModel(_ dictio : NSDictionary, _ idUser: String, complete: Bool) ->(ModelUser){
        let model = ModelUser()
        model.idUser = idUser
        model.alias = dictio["alias"] as? String ?? ""
        model.email = dictio["email"] as? String ?? ""
        model.houseId = dictio["houseId"] as? String ?? ""
        if (complete){
            if let valueRequest = dictio["solicitudes"] as? Dictionary<String, Any> {
                
                model.request = convertRequestMessageColection(valueRequest as! Array<String>)
            }
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
        
        var expenseDictio = Dictionary<String, Any>()
        var testDictio = Dictionary<String, Any>()
        for  item in model.expenses!{
            expenseDictio[item.idExpense!] = prepareExpense(model: item)
            testDictio[item.idExpense!] = expenseDictio
        }
        
        let billDictio = ["billId" : model.billId!,
                          "Date": BillManager().stringFromDate(date: model.dateBill!,format: constant.formatBillDate),
                          "expenses": testDictio,
                          "total": model.total!
            ] as Dictionary
        return billDictio
        
    }
    ///EXPENSE//
     //SET//
    func prepareExpense(model: ModelExpense) -> (Dictionary<String,Any>){
        //var expenseDictio = Dictionary<String, Any>()
        var usersDictio = Dictionary<String, Any>()
        for user in model.users!{
            let dictio = ["idUser": user.idUser]
            usersDictio = dictio as [String : Any]
        }
        let dict = [ "name": model.name!,
                     "idExpense":model.idExpense!,
                     "quantify": model.quantify!,
                     "selection" : model.selection!,
                     "color" : model.color!,
                     "ico": model.ico!,
                     "idBill" : model.idBill!,
                     "users" : usersDictio
            ] as Dictionary
        return dict
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
        model.users = dictio["users"] as? Array
        //
        print("HE SE HA MODIFOCADO ALGO")
        return model
    }
    
    func getListOfExpense(dictio: Dictionary <String, Any>) -> (Array<ModelExpense>){
        var arrayModel : Array<ModelExpense> = []
        let keys = dictio.keys
        for item in keys{
            let model = ModelExpense()
            model.idExpense = item
            arrayModel.append(model)
        }
        return arrayModel
    }
    
   
    
   
    
}
