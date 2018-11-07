//
//  supViewCollectionViewCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class supViewCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var supImageView: UIImageView!
    @IBOutlet weak var supTextView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var room : ModelRoom?
    var section : ModelHouseSection?
    var controller : supViewCollectionViewCellController?
    override func awakeFromNib() {
        super.awakeFromNib()
        controller = supViewCollectionViewCellController(cell : self)
        MainHelper.theStyle(view: mainView)
        priceLabel.textColor = UIColor .white
        mainView.layer.cornerRadius = mainView.frame.size.height / 4
       // initView()
    }
    
    func initView(){
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         //supImageView.layer.cornerRadius = supImageView.frame.size.height / 4
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
