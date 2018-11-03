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

        let sectionModel = ModelHouseSection()
        sectionModel.title = modal?.titleSectionTextField.text
        sectionModel.description = modal?.descriptionSectionTextField.text
       modal?.returnDataCreateSection?(sectionModel)
        
        
    }
    
}
