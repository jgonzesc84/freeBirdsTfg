//
//  RequestMessageFactory.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class RequestMessageFactory : BaseManager{
    
// ref.child("BILL").child(model.idBill!).child("expense").child(model.idExpense!).setValue(dictio)
   
    func prepareRequestHouse(_ model: ModelRequestHouse)-> Dictionary<String, Any> {
        let dictio = [ "idRequest": model.idRequest ?? "",
                       "aplicantId" : model.aplicantId ?? "",
                       "direction" : prepareDirection(model: model.direction!, new: false),
                       "date": model.date!.millisecondsSince1970,
                       "Mensajes" : prepareDictioMessageId(model.listofMessage![0]),
                       "state": model.state ?? "",
                       "requiredId": model.requiredId ?? ""
            
        ] as Dictionary
        return dictio
        
    }
    
    func setRequestHouse(_ dictio: NSDictionary) -> ModelRequestHouse{
        let model = ModelRequestHouse()
        model.idRequest = dictio["idRequest"] as? String ?? ""
        model.aplicantId = dictio["aplicantId"] as? String ?? ""
        model.direction = getDirection(dictio:dictio["direction"]  as! Dictionary<String, Any>)
        model.requiredId = dictio["requiredId"] as? String ?? ""
        
        let miliSeconds = dictio["date"] as? Int ?? 0
        model.date = Date(milliseconds: miliSeconds)
        model.listofMessage = setMessageList(dictio["Mensajes"] as! NSDictionary)
        model.state = dictio["state"] as? String ?? ""
        return model
    }
    
    func setMessageList(_ dictio: NSDictionary) -> (Array<ModelRequestMessageHouse>){
        
        let listCollection = dictio.allKeys
        var listOfMessage = Array<ModelRequestMessageHouse>()
        for idMessage in listCollection{
            let model = ModelRequestMessageHouse()
            let dictioInner = dictio[idMessage] as! Dictionary<String, Any>
            model.idRequestMessage = idMessage as? String
            model.text = dictioInner["text"] as? String ?? ""
            model.idUser = dictioInner["idUser"] as? String ?? ""
            model.name = (dictioInner["name"] as! String)
            //model.image = dictio[""] as? String ?? ""
            let miliSeconds = dictioInner["date"] as? Int ?? 0
            model.date = Date(milliseconds: miliSeconds)
            listOfMessage.append(model)
        }
        return listOfMessage
    }
    
    func setMessage( _ dictio : NSDictionary) -> (ModelRequestMessageHouse){
        let model = ModelRequestMessageHouse()
      //  let dictioInner = dictio[idMessage] as! Dictionary<String, Any>
        model.idRequestMessage = dictio["idMessage"] as? String ?? ""
        model.text = dictio["text"] as? String ?? ""
        model.idUser = dictio["idUser"] as? String ?? ""
        model.name = (dictio["name"] as! String)
        //model.image = dictio[""] as? String ?? ""
        let miliSeconds = dictio["date"] as? Int ?? 0
        model.date = Date(milliseconds: miliSeconds)
        return model
    }
    
    func prepareDictioMessageId(_ message: ModelRequestMessageHouse) -> Dictionary<String, Any>{
        
        let dictioInner = [ "idUser" : message.idUser!,
                            "text": message.text!,
                            "name": message.name!,
                            "date":message.date!.millisecondsSince1970
        ]as Dictionary
        let dictio = [ message.idRequestMessage! : dictioInner
        ]as Dictionary
        
        return dictio
    }
    func prepareMessageId(_ idMessage: String) -> Dictionary<String, Any>{
        var dictioMessage = Dictionary<String, Any>()
            dictioMessage = [ "idRequestMessage": idMessage
            ]
        return dictioMessage
    }
    
    func prepareMessageRequest(_ model: ModelRequestMessageHouse) -> Dictionary<String, Any>{
        
        let dictio = [
                        "idMessage" : model.idRequestMessage!,
                       "date": model.date!.millisecondsSince1970,
                       "idUser": model.idUser!,
                       "name" : model.name!,
                       "text" :model.text!,
                       "image":""
        ]as Dictionary
        return dictio
    }
    
    
    func createRequestToHouse(_ house: ModelHouse, _ text: String) -> ModelRequestHouse{
        
        let idUser = BaseManager().getUserDefault().idUser
        let model = ModelRequestHouse()
        model.aplicantId = idUser
        model.requiredId = house.idHouse
        model.direction = house.direction
        model.date = Date()
       
        model.listofMessage = Array()
        model.state = constant.stateOpendRequest
        
        let message = ModelRequestMessageHouse()
        message.text = text
        message.name = BaseManager().getUserDefault().alias
        message.idUser = idUser
        message.date = Date()
        model.listofMessage?.append(message)
        
        return model
    }
    
//    func orderMessageAsc( _ request: ModelRequestHouse) -> ModelRequestHouse{
//       let messages = request.listofMessage
//        let ordered = messages!.sorted(by:{$0.date!.compare($1.date!) == .orderedAscending})
//        request.listofMessage = ordered
//        return request
//    }
    func orderMessageAsc( _ list: Array<ModelRequestMessageHouse>) -> Array<ModelRequestMessageHouse>{
        let messages = list
        let ordered = messages.sorted(by:{$0.date!.compare($1.date!) == .orderedAscending})
        return ordered
    }
   
    
}
