//
//  ImageManager.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/06/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseStorage
class ImageManager{
    
    
    static let shared = ImageManager()
    
    var imageusersHouse = [ModelUser]()
    var mainUser = ModelUser()
    
    init() {
      
        mainUser = HouseManager.sharedInstance.mainUser!
    }
    
    func setUser(_ model:ModelUser){
        imageusersHouse.append(model)
    }
    
    func refreshMainUser(){
        mainUser = HouseManager.sharedInstance.mainUser!
    }
    func resetAll(){
        imageusersHouse.removeAll()
        mainUser = ModelUser()
    }
    func checkMainUserHasImage(completion:@escaping (ModelUser,Bool) -> Void){
        if (mainUser.imageData == nil){
            let url = mainUser.image
            if(url!.count > 0){
                Storage.storage().reference(forURL:url!).getData(maxSize:10 * 1024 * 1024,completion:{
                    (data, error) in
                    if let error = error?.localizedDescription{
                        print(error)
                    }else{
                        self.mainUser.imageData = UIImage(data:data!)
                        completion(self.mainUser,true)
                    }
                })
            }else{
            completion(ModelUser(),false)
            }
        }else{
            completion(ModelUser(),false)
        }
    }
    
}
