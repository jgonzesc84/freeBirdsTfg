//
//  ModelDebt.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 30/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelDebt{
    
    var idDebt: String?
    var user : ModelUser?
   // var userB: ModelUser?
    var debtor: [ModelExpense]?
    var creditor : [ModelCreditor]?
    var totalDebt = 0.00

    
    
}
