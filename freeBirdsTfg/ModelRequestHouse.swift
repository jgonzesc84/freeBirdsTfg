//
//  ModelRequestHouse.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelRequestHouse :Encodable{
    
    var idRequest: String?
    var aplicantId : String?
    var requiredId : String?
    var direction: ModelDirection?
    var listofMessage: Array<ModelRequestMessageHouse>?
    var date : Date?
    var state : String?
    var owner : Bool?
    
}

