//
//  ModelUser.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 11/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class ModelUser: Encodable{
    
    var idUser: String?
    var alias : String?
    var email : String?
    var telephoneNumber : String?
    var image: String?
    var imageData: UIImage?
    var houseId : String?
    var house : ModelHouse?
    var request : Array<ModelRequestHouse>?
    
    enum CodingKeys: String, CodingKey{
        case idUser
        case alias
        case email
        case telephoneNumber
        case image
        case houseId
        case house
        case request
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idUser, forKey: .idUser)
        try container.encode(alias, forKey: .alias)
        try container.encode(email, forKey: .email)
        try container.encode(telephoneNumber, forKey: .telephoneNumber)
        try container.encode(houseId, forKey: .houseId)
        try container.encode(house, forKey: .house)
        try container.encode(request, forKey: .request)
        
    }
    
}
