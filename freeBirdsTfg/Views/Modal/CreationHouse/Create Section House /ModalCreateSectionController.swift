//
//  ModalCreateSectionController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ModalCreateSectionController{
    
    //MARK: atributes
    
    var modal : ModalCreateSectionView?
    
    //MARK: init
    
    init(modalCreateSection: ModalCreateSectionView!){
        modal = modalCreateSection
        
    }
    
    //MARK: action button methods
    
    func acceptButton(){
        if (modal!.editMode!){
            editAccept()
        }else{
            createAccept()
        }
    }
    
    //MARK: private methods
    
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
