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
    var description : String?
    var listOfBill : Array<ModelBill>?
    var searchMate : Bool?
    var request : ModelRequestHouse?
    init(){

    }
    
    init(price: String?, section: Array<ModelHouseSection>? , listOfRoom: Array<ModelRoom>?, direction: ModelDirection?, completeDescription: String? /*, users: Array<Any>? */){

        self.price = price
        self.section = section
        self.listOfRoom = listOfRoom
        self.direction = direction
        self.description = completeDescription
       // self.user = Array()
       // self.user.append(BaseManager().getUserDefault())
      //  self.user = users

    }
    
    enum CodingKeys: String, CodingKey{
     
        case SECTIONS
        case ROOMS
        case DIRECTION
        case USER
        case IDHOUSE
        case DESCRIPTION
        case BILL
        case SEARCHMATE
        
        
    }

    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(section, forKey: .SECTIONS)
        try container.encode(listOfBill, forKey: .BILL)
        try container.encode(direction, forKey: .DIRECTION)
        try container.encode(listOfRoom, forKey: .ROOMS)
        try container.encode(user, forKey: .USER)
        try container.encode(searchMate, forKey: .SEARCHMATE)
        try container.encode(description, forKey: .DESCRIPTION)
        try container.encode(idHouse, forKey: .IDHOUSE)
        
        
    }
    
    
    
    
}
