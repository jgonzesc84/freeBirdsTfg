//
//  RequestMessageFactory.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class RequestMessageFactory{
    
    //devuelñve un diccionario
    func prepareRequestHouse(_ model: ModelRequestHouse)-> Dictionary<String, Any> {
       
        let dictio = [ "idRequest": model.idRequest ?? "",
                       "idUser" : model.idUser ?? "",
                       "direction" : model.direction ?? "",
                       "date": BillManager().stringFromDate(date:model.date!),
                       "listOfMessage" : prepareMessageId(model.listofMessage!)
        ] as Dictionary
        return dictio
        
    }
    func prepareMessageId(_ listMessage: Array<ModelRequestMessageHouse>) -> Dictionary<String, Any>{
        var dictioMessage = Dictionary<String, Any>()
        for item in listMessage{
            dictioMessage = [ "idRequestMessage": item.idRequestMessage!
            ]
        }
        return dictioMessage
    }
    
    /*
     func prepareRoom(model : ModelHouse) -> (Dictionary<String, Any>){
     var roomDictio = Dictionary<String, Any>()
     for item in model.listOfRoom! {
     let idRoom = Database.database().reference().childByAutoId().key
     let dict = ["user":item.user! ,
     "image":item.image as Any,
     "PRICE":item.price!,
     "search": item.search!
     ] as Dictionary
     roomDictio[idRoom] = dict
     
     }
     return roomDictio
     }
 
 
 */
}
