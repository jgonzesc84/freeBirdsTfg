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
        ImageManager.shared.checkRoomImage(model) {
            (room,matched) in
          //  model.imageData?.resizeImage(targetSize: (self.cell?.imageRoomView.frame.size)!)
            if(matched){
            let image = room.imageData
            self.cell?.imageRoomView.image = image
        }
        }
    }
    
    func resetCell(){
        cell?.priceLabel.text = ""
         //TODO: -imagen 
    }
}
