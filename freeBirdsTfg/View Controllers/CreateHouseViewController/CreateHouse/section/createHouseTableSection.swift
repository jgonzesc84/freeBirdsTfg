//
//  createHouseTableSection.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 15/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class createHouseTableSection: UITableViewHeaderFooterView {

    @IBOutlet weak var separatorTopLaneView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subLaneTitle: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
        
    }
    
    func initView(){
        titleLabel.textColor = UIColor .AppColor.Gray.greyApp
        titleLabel.font = UIFont .AppFont.middleFont.middlWord
        separatorTopLaneView.backgroundColor = UIColor .AppColor.Gray.greyApp
        subLaneTitle.backgroundColor = UIColor .AppColor.Green.mindApp
    }
    
}
