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
    @IBOutlet weak var testBackgroundView: UIView!
    @IBOutlet weak var messageView: UIView!
    
  
    var typeUser = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: testBackgroundView)
        self.selectionStyle = .none
        MainHelper.giveMeStyle(label: descriptionLabel)
        descriptionLabel.textColor = UIColor .black
        messageView.layer.cornerRadius = 5.0
        messageView.layer.borderColor = UIColor.black.cgColor
        messageView.layer.borderWidth = 2.0
        MainHelper.borderShadow(view: testBackgroundView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupCell(_ model:ModelRequestHouse){
        var title = ""
        if(typeUser){
            title = model.direction!
        }else{
             title = model.listofMessage!.first!.name!
        }
        let message = model.listofMessage!.last!
        directionLabel.text = title
        descriptionLabel.text = message.text
        nameLabel.text = message.name
        let stringdate = BillManager().stringFromDate(date: message.date!, format:constant.formatMeesageDate)
        dateLabel.text = stringdate
       
    }
    
}
