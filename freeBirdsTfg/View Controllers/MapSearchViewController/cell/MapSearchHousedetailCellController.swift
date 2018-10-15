//
//  MapSearchHpusedetailCellController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 15/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation

class MapSearchHousedetailCellController{
    
    var cell : MapSearchHousedetailCell?
    
    init(cell : MapSearchHousedetailCell ){
        self.cell = cell
    }
    
    func setupCell(model: ModelRoom){
        cell?.priceLabel.text = model.price
        //IMAGEN
    }
    
    func resetCell(){
        cell?.priceLabel.text = ""
        //imagen
    }
}
