//
//  MessageViewCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textInfoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var model : ModelRequestMessageHouse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setStyle(){
        MainHelper.circleView(view: userImageView)
        textInfoView.layer.cornerRadius = 10.0
        textInfoView.layer.borderWidth = 1
        textInfoView.layer.borderColor = UIColor .black .cgColor
        MainHelper.theStyle(view: textInfoView)
        MainHelper.theStyle(view: dateLabel)
        
    }

    func setupCell( _ model: ModelRequestMessageHouse){
        self.model = model
       // userImageView.image = model.Image
        infoLabel.text = model.text
        dateLabel.text = BillManager().stringFromDate(date: model.date!)
    }
   
    
}
