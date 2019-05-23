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
    func stringFromDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        return result
    }
    
    func compareDate(listArray:Array<ModelBill>) -> Array<ModelBill>{
      let sortedArray = listArray.sorted(by: { $0.dateBill!.compare($1.dateBill!) == .orderedDescending })
        return sortedArray
    }
    
    func oberveBill(){
         let billRef = Database.database().reference().child("BILL")
        billRef.child("idBill").child("expense").observe(.value) { (shot) in
            
        }
    }
}
