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
    @IBOutlet weak var principalView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: principalView)
        MainHelper.borderShadow(view: principalView)
        principalView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
