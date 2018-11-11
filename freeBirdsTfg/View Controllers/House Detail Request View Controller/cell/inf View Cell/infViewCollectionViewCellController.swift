//
//  infViewCollectionViewCellController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 09/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class infViewCollectionViewCellController{
    
    
    var cell : infViewCollectionViewCell?
    
    init(cell: infViewCollectionViewCell!){
        
        self.cell = cell
        
    }
    
    func setupCellWithRooom(room: ModelRoom){
        
       // cell!.titleLabel.isHidden = false
        cell!.titleLabel.text = room.price
        cell!.infImageView.image = UIImage(named:"stevenRoom Ico")
        
    }
    
    func setupCellWithSection(section: ModelHouseSection){
        
        //cell!.titleLabel.isHidden = false
        cell!.titleLabel.text = section.title
        cell!.infImageView.image = UIImage(named:"steven_playa ")
        
        
    }
    
    
    
}
