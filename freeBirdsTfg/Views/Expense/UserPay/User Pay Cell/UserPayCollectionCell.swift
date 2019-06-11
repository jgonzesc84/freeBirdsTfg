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
    var user: ModelUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selection = false
        MainHelper.theStyle(view: mainView)
        backGroundView.layer.cornerRadius = 20
        mainView.layer.cornerRadius = 20
        MainHelper.circleView(view: userImageView)
    }

    func setupCell(model: ModelUser){
        self.user = model
        nameLabel.text = model.alias
        //cargarImagen aqui
        ImageManager.shared.checkUserImage(model){(model, match) in
        if (match){
            let image = model.imageData?.resizeImage(targetSize: self.userImageView.frame.size)
           self.userImageView.image = image
        }else{
            
            }
        }
    }
    func touchCell() -> Bool{
        var value = false
        UIView.animate(withDuration: 0.25
            , animations: {
                self.backGroundView.alpha = self.selection! ? 0.65 : 0.0
                self.mainView.layer.borderWidth = self.selection!  ? 0 : 1
                self.mainView.layer.borderColor = self.selection! ? UIColor.white.cgColor : UIColor.AppColor.Gray.greyApp.cgColor
                
        }) { (finished: Bool) in
            
              self.selection = self.selection! ? false : true
          
        }
        if let aux = self.selection{
            value = aux
        }
        return value
    }
    
    
}
