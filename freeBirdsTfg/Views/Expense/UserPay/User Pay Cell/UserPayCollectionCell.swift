//
//  UserPayCollectionCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 17/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class UserPayCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MainHelper.theStyle(view: mainView)
    }

}
