//
//  ModalCreteRoomController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation


class ModalCreateRoomController{
    
    var modal : ModalCreateRoom?
    
    
    init(modalCreateRoom: ModalCreateRoom!){
        modal = modalCreateRoom
        
    }
    
    func acceptButton(){

        let roomModel = ModelRoom()
        roomModel.price = modal?.priceTextEdit.text!
        roomModel.user = modal?.userTextEdit.text!
        modal?.returnDataCreateRoom?(roomModel)
    }
    
}
