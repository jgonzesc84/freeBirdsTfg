//
//  ProfileTableViewCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellTextField: TextField!
    
    var controller : ProfileCellController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: mainView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
