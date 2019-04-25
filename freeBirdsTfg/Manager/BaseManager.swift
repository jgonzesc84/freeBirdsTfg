//
//  BaseManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 24/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import  CoreLocation

class BaseManager{
    
    
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
    
}
