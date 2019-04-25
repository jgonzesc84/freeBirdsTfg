//
//  UserPayCollectionCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 17/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class UserPayCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var selection : Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        selection = false
        MainHelper.theStyle(view: mainView)
        backGroundView.layer.cornerRadius = 20
        mainView.layer.cornerRadius = 20
    }

    func setupCell(model: ModelUser){
        
        nameLabel.text = model.alias
        if (model.image == nil){
           
        }
      
    }
    func touchCell(){
        UIView.animate(withDuration: 0.25
            , animations: {
                self.backGroundView.alpha = self.selection! ? 0.65 : 0.0
                self.mainView.layer.borderWidth = self.selection!  ? 0 : 1
                self.mainView.layer.borderColor = self.selection! ? UIColor.white.cgColor : UIColor.AppColor.Gray.greyApp.cgColor
        }) { (finished: Bool) in
            
            self.selection = self.selection! ? false : true
        }
        
    }
    
    
}
