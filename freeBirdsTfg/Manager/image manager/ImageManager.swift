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
    var imageSection = [ModelHouseSection]()
    var imageRooms = [ModelRoom]()
    var imageusersHouse = [ModelUser]()
    var mainUser = ModelUser()
    
    init() {
      
        if let mUserr = HouseManager.sharedInstance.mainUser{
             mainUser = mUserr
        }else{
            HouseManager.sharedInstance.mainUser = BaseManager().getUserDefault()
        }
       
    }
    
    func setUser(_ model:ModelUser){
        imageusersHouse.append(model)
    }
    
    func refreshMainUser(){
        mainUser = HouseManager.sharedInstance.mainUser!
    }
    func resetAll(){
        imageusersHouse.removeAll()
        imageSection.removeAll()
        imageRooms.removeAll()
        mainUser = ModelUser()
    }
    func checkMainUserHasImage(completion:@escaping (ModelUser,Bool) -> Void){
        if (mainUser.imageData == nil){
            if  let url = mainUser.image{
            if(url.count > 0){
                Storage.storage().reference(forURL:url).getData(maxSize:10 * 1024 * 1024,completion:{
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
    
    func checkUserImage(_ model:(ModelUser),completion:@escaping(ModelUser,Bool) -> Void){
    let matched  =  imageusersHouse.first(where:{$0.idUser == model.idUser })
        if (matched != nil){
            completion(matched!,true)
        }else{
            let url = model.image
            if(url!.count > 0){
                Storage.storage().reference(forURL:url!).getData(maxSize:10 * 1024 * 1024,completion:{
                    (data, error) in
                    if let error = error?.localizedDescription{
                        print(error)
                    }else{
                        model.imageData = UIImage(data:data!)
                        self.imageusersHouse.append(model)
                        completion(model,true)
                    }
                })
            }else{
                print("no hay imagen")
                 completion(ModelUser(),false)
            }
        }
        
    }
    func chechSectionImage(_ model:(ModelHouseSection), completion:@escaping(ModelHouseSection,Bool) -> Void){
        let matched = imageSection.first(where:{$0.image == model.image})
        if (matched != nil){
            completion(matched!,true)
        }else{
            if  let url = model.image{
                if(url.count > 0){
                    Storage.storage().reference(forURL:url).getData(maxSize:10 * 1024 * 1024,completion:{
                        (data, error) in
                        if let error = error?.localizedDescription{
                            print(error)
                        }else{
                            model.imageData = UIImage(data:data!)
                            self.imageSection.append(model)
                            completion(model,true)
                        }
                    })
                }else{
                    print("no hay imagen")
                    completion(ModelHouseSection(),false)
                }
            }else{
                if let _ = model.imageData{
                   completion(model,true)
                }else{
                    completion(ModelHouseSection(),false)
                }
               
            }
           
        }
    }
    
    func checkRoomImage(_ model:(ModelRoom),completion:@escaping(ModelRoom,Bool) -> Void){
        let matched  =  imageRooms.first(where:{$0.idRoom == model.idRoom })
        if (matched != nil){
            completion(matched!,true)
        }else{
            if  let url = model.image{
                if(url.count > 0){
                    Storage.storage().reference(forURL:url).getData(maxSize:10 * 1024 * 1024,completion:{
                        (data, error) in
                        if let error = error?.localizedDescription{
                            print(error)
                        }else{
                            model.imageData = UIImage(data:data!)
                            self.imageRooms.append(model)
                            completion(model,true)
                        }
                    })
                }else{
                    print("no hay imagen")
                    completion(ModelRoom(),false)
                }
            }
           else{
                print("no hay imagen")
                completion(ModelRoom(),false)
            }
        }
        
    }
   
}
