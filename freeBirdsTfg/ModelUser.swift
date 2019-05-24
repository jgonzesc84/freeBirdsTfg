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
    var houseId : String?
    var house : ModelHouse?
    var request : Array<ModelRequestHouse>?
    
    
    
}
