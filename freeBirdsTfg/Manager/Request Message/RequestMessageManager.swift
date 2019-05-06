//
//  RequestMessageManager.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RequestMessageManager{
    let factory = RequestMessageFactory()

    func insertRequest(_ model: ModelRequestHouse ,completion:@escaping(Bool) -> Void){
        
        let ref = Database.database().reference()
        model.idRequest = ref.childByAutoId().key
        let idMessage =  ref.childByAutoId().key
        model.listofMessage?[0].idRequestMessage = idMessage
        
        ref.child("SOLICITUD").child(model.idRequest!).setValue(factory.prepareRequestHouse(model)){
            (error:Error?, ref:DatabaseReference)in
            if error != nil{
            completion(false)
            }else{
                self.setRequestUser(model, completion: { (succes) in
                    if(succes){
                        self.setRequestHouse(model, completion: { (succes) in
                            if(succes){
                                self.insertMessageFromRequest(model.listofMessage![0], completion: { (succes) in
                                    if(succes){
                                        completion(true)
                                    }
                                })
                            }
                        })
                    }
                })
              
            }
        }
    }
    func setRequestUser(_ model : ModelRequestHouse, completion:@escaping(Bool) -> Void){
          let ref = Database.database().reference()
        ref.child("USUARIO").child(model.idUser!).child("solicitudes").child(model.idRequest!).setValue(model.idRequest!){
             (error:Error?, ref:DatabaseReference)in
            if error != nil{
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func setRequestHouse(_ model : ModelRequestHouse ,completion:@escaping(Bool) -> Void){
          let ref = Database.database().reference()
        ref.child("CASA").child(model.idHouse!).child("SOLICITUD").child(model.idRequest!).setValue(model.idRequest!){
              (error:Error?, ref:DatabaseReference)in
            if error != nil{
                 completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func insertMessageFromRequest(_ model: ModelRequestMessageHouse ,completion:@escaping(Bool) -> Void){
         let ref = Database.database().reference()
       //  model.idRequestMessage = ref.childByAutoId().key
        ref.child("MENSAJES").child(model.idRequestMessage!).setValue(factory.prepareMessageRequest(model)){
             (error:Error?, ref:DatabaseReference)in
            if error != nil{
                 completion(false)
            }else{
                completion(true)
            }
        }
    }

}
