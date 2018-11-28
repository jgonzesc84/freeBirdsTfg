//
//  MapSearchHpusedetailCellController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 15/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation

class MapSearchHousedetailCellController{
     //MARK: atributes
    
    var cell : MapSearchHousedetailCell?
      //MARK: init
    init(cell : MapSearchHousedetailCell ){
        self.cell = cell
    }
    
    //MARK: setup cell
    func setupCell(model: ModelRoom){
        cell?.priceLabel.text = model.price
        //TODO: -imagen
    }
    
    func resetCell(){
        cell?.priceLabel.text = ""
         //TODO: -imagen 
    }
}
