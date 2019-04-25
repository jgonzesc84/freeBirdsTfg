//
//  HouseManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



protocol refreshHouseData: class {
    func refresh()
}

class HouseManager : BaseManager{
    //gastos collection
     var user :  Array<ModelUser>?
     var house : ModelHouse?
     weak var delegate: refreshHouseData?
    
    static let sharedInstance = HouseManager()
    private override init (){}
    
    func setupData(){
        fillHouse(idHouse: getUserDefault().houseId ?? "default"){(finish) in
            if (finish){
                self.fillUser()
            }
        }
    }
    
    func fillHouse(idHouse: String , completion:@escaping (Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).observe(.value, with: { (shot) in
            self.house = ModelHouse()
            let value = shot.value as? NSDictionary
            self.house = self.parseHouse(dictioHouse: value!)
            self.user = self.house?.user
              completion(true)
        }, withCancel: { (error) in
          
        })
    }
    
    func fillUser(){
        //llamada recursiva para rellenar a todos los usuarios
    }
    
}
