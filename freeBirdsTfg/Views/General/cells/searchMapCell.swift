//
//  searchMapCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 14/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class searchMapCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: mainView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
