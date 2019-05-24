//
//  ModelHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
class ModelHouse : Encodable{
    
    var price : String?
    var section : Array<ModelHouseSection>?
    var listOfRoom : Array<ModelRoom>?
    var direction : ModelDirection?
    var user : Array<ModelUser>?
    var idHouse : String?
    var completeDescription : String?
    var listOfBill : Array<ModelBill>?
    var searchMate : Bool?
    init(){

    }
    
    init(price: String?, section: Array<ModelHouseSection>? , listOfRoom: Array<ModelRoom>?, direction: ModelDirection?, completeDescription: String? /*, users: Array<Any>? */){

        self.price = price
        self.section = section
        self.listOfRoom = listOfRoom
        self.direction = direction
        self.completeDescription = completeDescription
       // self.user = Array()
       // self.user.append(BaseManager().getUserDefault())
      //  self.user = users

    }

    
    
    
    
}
