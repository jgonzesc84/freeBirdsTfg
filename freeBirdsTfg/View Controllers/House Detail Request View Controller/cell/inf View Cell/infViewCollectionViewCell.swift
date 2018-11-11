//
//  infViewCollectionViewCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class infViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var controller : infViewCollectionViewCellController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MainHelper.theStyle(view: self)
        controller = infViewCollectionViewCellController(cell : self)
        initView()
    }
    
    func initView(){
        MainHelper.giveMeStyle(label: titleLabel)
        
    }

    func setupCell(model: Any){
        switch model {
        case is ModelRoom:
            
            controller?.setupCellWithRooom(room: model as! ModelRoom)
            //  layoutSubviews()
            
            break
        case is ModelHouseSection:
            
            controller?.setupCellWithSection(section: model as! ModelHouseSection)
            //  layoutSubviews()
            
            break;
        default:
            
            break
        }
    }
}
