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
//                                self.insertMessageFromRequest(model.listofMessage![0], completion: { (succes) in
//                                    if(succes){
//                                        completion(true)
//                                    }
//                                })
                                completion(true)
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
        let dictio = ["idRequest" : model.idRequest
        ]as Dictionary
        ref.child("CASA").child(model.idHouse!).child("SOLICITUD").child(model.idRequest!).setValue(dictio){
              (error:Error?, ref:DatabaseReference)in
            if error != nil{
                 completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func insertMessageFromRequest(_ message: ModelRequestMessageHouse, _ request : ModelRequestHouse ,completion:@escaping(Bool) -> Void){
         let ref = Database.database().reference()
        // message.idRequestMessage = ref.childByAutoId().key
        ref.child("SOLICITUD").child(request.idRequest!).child("Mensajes").child(message.idRequestMessage!).setValue(factory.prepareMessageRequest(message)){
             (error:Error?, ref:DatabaseReference)in
            if error != nil{
                 completion(false)
            }else{
                completion(true)
            }
        }
    }

    
    func getRequestAddedUser( _ idUser: String){
        let ref = Database.database().reference()
        ref.child("USUARIO").child(idUser).child("solicitudes").observe(.childAdded, with:{ shot in
            if let data = shot.value as? NSDictionary{
                print("mierda")
            }
    })
    }
    
        func getAllRequest( _ idUser:String, completion:@escaping(Array<ModelRequestHouse>,Bool) -> Void){
            let ref = Database.database().reference()
            ref.child("USUARIO").child(idUser).child("solicitudes").observeSingleEvent(of: DataEventType.value) { (shot) in
                var listOfRequest = Array <ModelRequestHouse>()
                if let data = shot.value as? NSDictionary {
                   let listId = data.allKeys
                    let countMe = listId.count
                    var test = 0
                    for idRequest in listId{
                        self.getRequestWithId(idRequest as! String, completion: { (model) in
                           listOfRequest.append(model)
                             test += 1
                            if(test == countMe){
                                completion(listOfRequest,true)
                            }
                            
                        })
                        
                    }
                    
                }else{
                   completion(listOfRequest,false)
                }
            }
        }
    
    func getRequestWithId( _ requestId: String, completion: @escaping(ModelRequestHouse) -> Void){
        let ref = Database.database().reference()
        ref.child("SOLICITUD").child(requestId).observeSingleEvent(of: DataEventType.value) { (shot) in
            if let data = shot.value as? NSDictionary {
                let model = self.factory.setRequestHouse(data)
                completion(model)
            }
            
        }
    }
    
    //observer
    func listChangeOnMessages(_ request:ModelRequestHouse, completion: @escaping(ModelRequestMessageHouse) -> Void){
         let ref = Database.database().reference()
        ref.child("SOLICITUD").child(request.idRequest!).child("Mensajes").queryLimited(toLast: 1).observe(.childAdded) { (shot) in
            if let data = shot.value as? NSDictionary{
                let model = self.factory.setMessage(data)
                completion(model)
            }
        }
        
    }
    
    func giveMeId() -> String{
        let ref = Database.database().reference()
        return ref.childByAutoId().key
    }
}



/*
 var fullHouse = ModelHouse()
 if let data = shot.value as? NSDictionary {
 fullHouse = self.parseHouse(dictioHouse: data)
 }
 completion(fullHouse,true)
 
 */

