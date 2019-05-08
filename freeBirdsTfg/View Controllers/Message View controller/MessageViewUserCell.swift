//
//  MessageViewUserCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 07/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class MessageViewUserCell: UITableViewCell {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabelUser: UILabel!
    @IBOutlet weak var textInfoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
     var model : ModelRequestMessageHouse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    func setStyle(){
        self.selectionStyle = .none
        MainHelper.circleView(view: userImageView)
        textInfoView.layer.cornerRadius = 10.0
        textInfoView.layer.borderWidth = 1
        textInfoView.layer.borderColor = UIColor .black .cgColor
        MainHelper.theStyle(view: textInfoView)
        MainHelper.giveMeStyle(label: dateLabel)
        MainHelper.giveMeStyle(label: nameLabelUser)
        infoLabel.textColor = UIColor .black
    }
    
    func setupCell( _ model: ModelRequestMessageHouse){
        self.model = model
        nameLabelUser.text = model.name
        infoLabel.text = model.text
        dateLabel.text = BillManager().stringFromDate(date: model.date!, format:constant.formatMeesageDate)
        infoLabel.textColor = UIColor .black
       // infoLabel.sizeToFit()
        if(model.temporal ?? false){
            infoLabel.textColor = UIColor .AppColor.Gray.greyApp
        }
        
    }
    
    
    
}
