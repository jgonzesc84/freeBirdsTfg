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
    var search : Bool?
    var idRoom : String?
    
}
