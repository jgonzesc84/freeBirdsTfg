//
//  ModelPayment.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 30/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelPayment:  Encodable{
    
    var idPayment: String?
   // var idExpense: String?
    var quantify = 0.00
   // var user : ModelUser?
    var idUser : String?
    
    var payed = 0.00
    
}
