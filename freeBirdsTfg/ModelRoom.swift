//
//  ModelRoom.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 12/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class ModelRoom: Encodable{
    
    var user : ModelUser?
    var price : String!
    var image : String?
    var imageData : UIImage?
    var search : Bool?
    var idRoom : String?
    
    enum CodingKeys: String, CodingKey{
        
        case user
        case search
        case PRICE
       
        
        
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(price, forKey: .PRICE)
        try container.encode(search, forKey: .search)
      
    }
    
}
