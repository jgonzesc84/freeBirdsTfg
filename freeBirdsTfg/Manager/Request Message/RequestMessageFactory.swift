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
                       "date": model.date!.asString(),
                       "listOfMessage" : prepareDictioMessageId(model.listofMessage![0].idRequestMessage!)
        ] as Dictionary
        return dictio
        
    }
    
    func prepareDictioMessageId(_ idMessage: String) -> Dictionary<String, Any>{
        let dictio = [ "idMessage" : idMessage
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
                       "date": model.date!.asString(),
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
