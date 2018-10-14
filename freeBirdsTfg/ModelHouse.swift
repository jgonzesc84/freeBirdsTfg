//
//  ModelHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
class ModelHouse{
    
    var price : String?
    var section : Array<ModelHouseSection>?
    var listOfRoom : Array<ModelRoom>?
    var direction : ModelDirection?
    var user : Array<Any>?
    var idHouse : String?
    init(price: String?, section: Array<ModelHouseSection>? , listOfRoom: Array<ModelRoom>?, direction: ModelDirection? /*, users: Array<Any>? */){
        
        self.price = price
        self.section = section
        self.listOfRoom = listOfRoom
        self.direction = direction
      //  self.user = users
        
    }
    
    
    
    
    
}
