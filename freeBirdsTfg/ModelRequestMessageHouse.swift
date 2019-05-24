//
//  ModelRequestMessageHouse.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelRequestMessageHouse : Encodable{
    
    var idRequestMessage : String?
    var text : String?
    var idUser : String?
    var name : String?
    var date: Date?
    var Image : String?
    var temporal: Bool?
    
}
