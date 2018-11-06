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
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func setupCell(){
        
    }
}
