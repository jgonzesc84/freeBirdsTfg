//
//  BillManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class BillManager : BaseManager{
    
    func createDate() -> (Date){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        let result = formatter.string(from: date)
        let finishDate = formatter.date(from: result)
        return finishDate!
 
    }
    func stringFromDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func compareDate(){
        
    }
    
}
