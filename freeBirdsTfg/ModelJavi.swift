//
//  ModelJavi.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 24/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelJavi: Encodable{
    
    var name : String?
    var sexuality: Bool?
    var age: Int?
    var direccion : ModelDirection?
    
    init() {
        
    }
    init(name:String, sexuality:Bool, age:Int) {
        
        self.name = name
        self.sexuality = sexuality
        self.age = age
        
    }
}
