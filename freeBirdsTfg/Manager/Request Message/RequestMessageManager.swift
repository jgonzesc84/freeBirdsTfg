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
    //request de un usuario
    func setRequestUser(_ model : ModelRequestHouse, completion:@escaping(Bool) -> Void){
          let ref = Database.database().reference()
        var path = ""
       let value = model.aplicantId == BaseManager().userId()
        path = value ? model.aplicantId! : model.requiredId!
        ref.child("USUARIO").child(path).child("solicitudes").child(model.idRequest!).setValue(model.idRequest!){
             (error:Error?, ref:DatabaseReference)in
            if error != nil{
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    //
    func setRequestHouse(_ model : ModelRequestHouse ,completion:@escaping(Bool) -> Void){
        let ref = Database.database().reference()
        let dictio = ["idRequest" : model.idRequest
        ]as Dictionary
        var path = ""
        let value = model.aplicantId == BaseManager().houseId()
        path = value ? model.aplicantId! : model.requiredId!
        ref.child("CASA").child(path).child("SOLICITUD").child(model.idRequest!).setValue(dictio){
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
        ref.child("CASA").child(BaseManager().getUserDefault().houseId!).child("SOLICITUD").observe(.value) { (shot) in
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
        ref.child("USUARIO").child(idUser).child("solicitudes").observe(.childAdded , with:{ (shot) in
            if let data = shot.value as? NSDictionary {
                let idRequest = data.allKeys[0] as! String
                self.getRequestWithId(idRequest, completion: { (request) in
                    completion(request)
                })
            }
        })
        
    }
    
    func requestIsDeletedHouse(idHouse: String,completion:@escaping(String) -> Void){
        let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).child("SOLICITUD").observe(.childRemoved , with:{ (shot) in
            if let data = shot.value as? NSDictionary {
                let idRequest = data["idRequest"] as? String ?? ""
               completion(idRequest)
            }
        })
    }
    func requestIsDeletedUser(idUser: String,completion:@escaping(String) -> Void){
        let ref = Database.database().reference()
        ref.child("USUARIO").child(idUser).child("solicitudes").observe(.childRemoved , with:{ (shot) in
            if let data = shot.value as? String {
                let idRequest = data
                completion(idRequest)
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
    func deleteRequestFromHouse(request:ModelRequestHouse,idHouse:String,completion:@escaping(Bool) -> Void){
         let ref = Database.database().reference()
        ref.child("CASA").child(idHouse).child("SOLICITUD").child(request.idRequest!).removeValue(){
            (error:Error?, ref:DatabaseReference)in
            if error != nil{
                completion(false)
            }else{
//                if(request.idHouse != nil){
//                    self.deleteRequest(idRequest: request.idRequest!)
//                    completion(true)
//                }
//               
            }
        }
    }
    
    func deleteRequestFromUser(request:ModelRequestHouse,idUser:String,completion:@escaping(Bool) -> Void){
          let ref = Database.database().reference()
         ref.child("USUARIO").child(idUser).child("solicitudes").child(request.idRequest!).removeValue(){
            (error:Error?, ref:DatabaseReference)in
            if error != nil{
                 completion(false)
            }else{
//                if(request.idUser != nil){
//                    self.deleteRequest(idRequest: request.idRequest!)
//                    completion(true)
//                }
                
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
    /*
     requestMng.changeStateRequest(model!.idRequest!, state:constant.statcDeclineRequest){ (succes) in
     if(succes){
     let requestMng = RequestMessageManager()
     let houseId = BaseManager().getUserDefault().houseId
     let value =  houseId != "0"
     self.resfreshViewDeleted(value, request:  self.model!, idHouse: houseId!, manager: requestMng)
     }
     }
     manager.deleteRequestFromUser(request:request, idUser: (self.model?.aplicantId!)!){(sucess) in
     
     }
 */
    func setCancellAllRequestUser(listOfRequest:Array<ModelRequestHouse>,idAccepted: String){
        for request in listOfRequest{
            if(idAccepted != request.idRequest){
                self.changeStateRequest(request.idRequest!,state: constant.statcDeclineRequest){(sucess) in
                    if(sucess){
                        self.deleteRequestFromUser(request: request, idUser:BaseManager().userId()){
                            (sucess) in
                        }
                    }
                }
            }else{
                self.changeStateRequest(request.idRequest!,state: constant.stateAcceptRequest){(sucess) in
                    if(sucess){
                        self.deleteRequestFromUser(request: request, idUser:BaseManager().userId()){
                            (sucess) in
                        }
                    }
                }
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


