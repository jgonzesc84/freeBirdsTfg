//
//  supViewCollectionViewCellController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 07/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class supViewCollectionViewCellController{
    
    var cell : supViewCollectionViewCell?
    
    init(cell: supViewCollectionViewCell!){
        
        self.cell = cell
        
    }
    
    func setupCellWithRooom(room: ModelRoom){
        
       cell!.priceLabel.isHidden = false
       cell!.supTextView.isHidden = true
       cell!.priceLabel.text = room.price
       cell!.supImageView.image = UIImage(named:"stevenRoom Ico")
        
    }
    
    func setupCellWithSection(section: ModelHouseSection){
        
        cell!.priceLabel.isHidden = true
        cell!.supTextView.isHidden = false
        cell!.supImageView.image = UIImage(named:"steven_playa ")
        if(section.description.count > 0){
           cell!.supTextView.text = section.description
        }else{
            cell!.supTextView.isHidden = true
        }
        
    }
    
}
