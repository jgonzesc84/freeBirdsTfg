//
//  ModelExpense.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelExpense{
    
    var idExpense: String?
    var idBill: String?
    var name: String?
    var quantify: Double?
    var selection:Bool?
    var color: String?
    var ico: String?
    var users: Array<ModelUser>?
    var idUser: String?
    
    init(){
        
    }
    
}
