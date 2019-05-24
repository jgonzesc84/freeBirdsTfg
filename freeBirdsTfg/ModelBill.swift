//
//  ModelBill.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModelBill: Encodable{
    
    var billId: String?
    var dateBill: Date?
    var total : Double?
    var expenses: Array<ModelExpense>?
    init(){
        
    }
    
    enum CodingKeys: String, CodingKey{
        case dateBill
        case billId
        case expenses
        case total
       
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateBill?.millisecondsSince1970, forKey: .dateBill)
        try container.encode(billId, forKey: .billId)
        try container.encode(expenses, forKey: .expenses)
        try container.encode(total, forKey: .total)
       
    }
   
}




