//
//  RequestMessageFactory.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class RequestMessageFactory{
    
// ref.child("BILL").child(model.idBill!).child("expense").child(model.idExpense!).setValue(dictio)
   
    func prepareRequestHouse(_ model: ModelRequestHouse)-> Dictionary<String, Any> {
        let dictio = [ "idRequest": model.idRequest ?? "",
                       "idUser" : model.idUser ?? "",
                       "direction" : model.direction ?? "",
                       "date": model.date!.millisecondsSince1970,
                       "Mensajes" : prepareDictioMessageId(model.listofMessage![0])
            
        ] as Dictionary
        return dictio
        
    }
    
    func setRequestHouse(_ dictio: NSDictionary) -> ModelRequestHouse{
        let model = ModelRequestHouse()
        model.idRequest = dictio["idRequest"] as? String ?? ""
        model.idUser = dictio["idUser"] as? String ?? ""
        model.direction = dictio["direction"] as? String ?? ""
        let miliSeconds = dictio["date"] as? Int ?? 0
        model.date = Date(milliseconds: miliSeconds)
        model.listofMessage = setMessage(dictio["Mensajes"] as! NSDictionary)
        return model
    }
    
    func setMessage(_ dictio: NSDictionary) -> (Array<ModelRequestMessageHouse>){
        let model = ModelRequestMessageHouse()
        let listCollection = dictio.allKeys
        var listOfMessage = Array<ModelRequestMessageHouse>()
        for idMessage in listCollection{
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
    
   
    
    func prepareDictioMessageId(_ message: ModelRequestMessageHouse) -> Dictionary<String, Any>{
        
        let dictioInner = [ "idUser" : message.idUser!,
                            "text": message.text!,
                            "name": message.name!,
                            "date":message.date!.timeIntervalSince1970
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
        
        let dictio = [ "idRequestMessage": model.idRequestMessage!,
                       "idUser": model.idUser!,
                       "name" : model.name!,
                       "text" :model.text!,
                       "date": model.date!.millisecondsSince1970,
                       "image":""
        ]as Dictionary
        return dictio
    }
    
    
    func createRequest(_ house: ModelHouse, _ text: String) -> ModelRequestHouse{
        
        let idUser = BaseManager().getUserDefault().idUser
        let model = ModelRequestHouse()
        model.idHouse = house.idHouse
        model.direction = house.direction?.title
        model.date = Date()
        model.idUser = idUser
        model.listofMessage = Array()
        
        let message = ModelRequestMessageHouse()
        message.text = text
        message.name = BaseManager().getUserDefault().alias
        message.idUser = idUser
        message.date = Date()
        model.listofMessage?.append(message)
        
        return model
    }
    
    
   
}
