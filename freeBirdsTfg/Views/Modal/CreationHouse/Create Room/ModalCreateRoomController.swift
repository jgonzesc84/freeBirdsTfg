//
//  ModalCreteRoomController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation


class ModalCreateRoomController{
    
    //MARK: atributes
    
    var modal : ModalCreateRoom?
    var editMode : Bool?
    var returnDataCreateSection: ((ModelHouseSection) -> ())?
    
    //MARK: init view
    
    init(modalCreateRoom: ModalCreateRoom!){
        modal = modalCreateRoom
        
    }
    
    //MARK:action button view
    
    func acceptButton(){
        
        modal!.editMode! ? editAccept() : createAccept()
    }
    //MARK:private methods
    
    func createAccept(){
        let roomModel = ModelRoom()
        roomModel.price = modal?.priceTextEdit.text!
        roomModel.user?.idUser = modal?.userTextEdit.text!
        roomModel.search = modal?.searchSelection!
        modal?.returnDataCreateRoom?(roomModel)
    }
    
    func editAccept(){
        let roomModel = ModelRoom()
        roomModel.price = modal?.priceTextEdit.text!
        roomModel.user?.idUser = modal?.userTextEdit.text!
        roomModel.search = modal?.searchSelection!
        modal?.returnDataEditRoom?(roomModel)
    }
    
}
