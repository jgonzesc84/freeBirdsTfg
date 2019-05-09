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
                let listOfRequest = Array <ModelRequestHouse>()
                if let data = shot.value as? NSDictionary {
                    self.dataFromRequestService( dictio: data, completion: { (list, sucess) in
                        completion(list, true)
                    })
                }else{
                    completion(listOfRequest,false)
                }

            }
        }
    
    func getAllRequestHouse( _ idHouse: String, completion:@escaping(Array<ModelRequestHouse>,Bool) -> Void){
         let ref = Database.database().reference()
        ref.child("CASA").child(BaseManager().getUserDefault().houseId!).child("SOLICITUD").observeSingleEvent(of: DataEventType.value) { (shot) in
              let listOfRequest = Array <ModelRequestHouse>()
              if let data = shot.value as? NSDictionary {
                self.dataFromRequestService( dictio: data, completion: { (list, sucess) in
                    completion(list, true)
                })
              }else{
              completion(listOfRequest,false)
            }
        }
    }
    
    func dataFromRequestService( dictio : NSDictionary, completion:@escaping(Array<ModelRequestHouse>,Bool) -> Void){
        var listOfRequest = Array <ModelRequestHouse>()
        
        let listId = dictio.allKeys
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
    
   
    ///////////////////////////////////EDITED
    func getRequestEdited( _ idRequest:String, completion:@escaping(ModelRequestHouse) -> Void){
        let ref = Database.database().reference()
        ref.child("SOLICITUD").child(idRequest).observe(.value , with:{ (shot) in
            if let data = shot.value as? NSDictionary {
            let model = self.factory.setRequestHouse(data)
            completion(model)
            }
        })
    }
    
    
    
    func requestAddedHouse( idHouse: String,completion:@escaping(ModelRequestHouse) -> Void){
         let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).child("SOLICITUD").observe(.childAdded , with:{ (shot) in
            if let data = shot.value as? NSDictionary {
               let idRequest = data["idRequest"] as? String ?? ""
                self.getRequestWithId(idRequest, completion: { (request) in
                    completion(request)
                })
            }
        })
        
    }
    func requestAddedUser( idUser: String,completion:@escaping(ModelRequestHouse) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").child(idUser).child("solicitudes").observe(.childAdded , with:{ (shot) in
            if let data = shot.value as? NSDictionary {
                let idRequest = data.allKeys[0] as! String
                self.getRequestWithId(idRequest, completion: { (request) in
                    completion(request)
                })
            }
        })
        
    }
    //// SET STATE
    func changeStateRequest( _ idRequest:String, state: String,completion:@escaping(Bool) -> Void){
        let ref = Database.database().reference()
        ref.child("SOLICITUD").child(idRequest).child("state").setValue(state){
            (error:Error?, ref:DatabaseReference)in
        if error != nil{
            completion(false)
        }else{
            completion(true)
        }
    }
    }
    //DELETE REQUEST
    func deleteRequestFromHouse(request:ModelRequestHouse,idHouse:String){
         let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).child("SOLICITUD").child(request.idRequest!).removeValue(){
            (error:Error?, ref:DatabaseReference)in
            if error != nil{
                
            }else{
                if(request.idHouse != nil){
                    self.deleteRequest(idRequest: request.idRequest!)
                }
               
            }
        }
    }
    
    func deleteRequestFromUser(request:ModelRequestHouse,idUser:String){
          let ref = Database.database().reference()
         ref.child("USUARIO").child(idUser).child("solicitudes").child(request.idRequest!).removeValue(){
            (error:Error?, ref:DatabaseReference)in
            if error != nil{
                
            }else{
                if(request.idUser != nil){
                    self.deleteRequest(idRequest: request.idRequest!)
                }
                
            }
        }
    }
    func deleteRequest(idRequest: String){
        let ref = Database.database().reference()
        ref.child("SOLICITUD").child(idRequest).removeValue{
             (error:Error?, ref:DatabaseReference)in
            if error != nil{
               
            }else{
               
            }
        }
    }
    //MESSAGE
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


