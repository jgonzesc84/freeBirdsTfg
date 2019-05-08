//
//  RequestCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: mainView)
        self.selectionStyle = .none
        MainHelper.giveMeStyle(label: descriptionLabel)
        descriptionLabel.textColor = UIColor .black
        messageView.layer.cornerRadius = 5.0
        messageView.layer.borderColor = UIColor.black.cgColor
        messageView.layer.borderWidth = 2.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor .AppColor.Gray.greyApp.cgColor
        contentView.layer.borderWidth = 1.0
        
      //  MainHelper.borderShadow(view: contentView)
    }
    
    func setupCell(_ model:ModelRequestHouse){
        let message = model.listofMessage!.last!
        directionLabel.text = model.direction
        descriptionLabel.text = message.text
        nameLabel.text = message.name
        let stringdate = BillManager().stringFromDate(date: message.date!, format:constant.formatMeesageDate)
        dateLabel.text = stringdate
       
    }
    
}
