//
//  ModalCreateSectionController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModalCreateSectionController{
    
   
    var modal : ModalCreateSectionView?
    
    init(modalCreateSection: ModalCreateSectionView!){
        modal = modalCreateSection
        
    }
    
    func acceptButton(){
        if (modal!.editMode!){
            editAccept()
        }else{
            createAccept()
        }
    }
    
    func createAccept(){

        let sectionModel = ModelHouseSection()
        sectionModel.title = modal?.titleSectionTextField.text
        sectionModel.description = modal?.descriptionSectionTextField.text
        modal?.returnDataCreateSection?(sectionModel)
        
    }
    
    func editAccept(){
        let sectionModel = ModelHouseSection()
        sectionModel.title = modal?.titleSectionTextField.text
        sectionModel.description = modal?.descriptionSectionTextField.text
        modal?.returnDataEditSection?(sectionModel)
    }
    
}
