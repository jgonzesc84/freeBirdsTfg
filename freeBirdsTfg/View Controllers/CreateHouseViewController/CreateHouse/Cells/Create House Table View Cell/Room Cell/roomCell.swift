//
//  roomExpandibleCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 8/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class roomCell: UITableViewCell  {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    
    //addRoom outlet
    
    @IBOutlet weak var userlabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    public var fill : Bool = false
    var model : ModelRoom?
    //clousure
    public var showModal: ((roomCell) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        MainHelper.borderShadow(view: roomView)
    }

  /*  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }*/
    
    private func commonInit(){
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        MainHelper.theStyle(view: addView)
        MainHelper.theStyle(view: roomView)
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        //roomImageView.layer.cornerRadius = roomImageView.frame.size.width/4
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        addView.isHidden = false
        roomView.isHidden = true
        userImageView.isHidden = true
        
    }
    
   public func setup(room: ModelRoom?){
        model = room
    if (room != nil){
        userlabel.text = room?.user?.alias
        priceLabel.text = room?.price
        if let imageData = room?.imageData{
            roomImageView.image = imageData
        }
        if let user = room?.user{
            if let alias = user.alias{
                if (alias.count > 0){
                    imageView?.isHidden = false
                    ImageManager.shared.checkUserImage(user){(model, match) in
                        if (match){
                            let image = model.imageData?.resizeImage(targetSize: self.userImageView.frame.size)
                            self.userImageView.isHidden = false
                            self.userImageView.clipsToBounds = true
                            self.userImageView.image = image
                        }else{
                            
                        }
                    }
                }
            }
            
        }
        addView.isHidden = true
        roomView.isHidden = false
        //WALLY
        ImageManager.shared.checkRoomImage(model!){
            (room,match) in
            if(match){
                if  let image = room.imageData{
                    self.roomImageView.image = image
                    self.model!.imageData = image
                }
              
            }
        }
        }
    }

    func reset(){
        addView.isHidden = false
        roomView.isHidden = true
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
    showModal?(self)
        
    }
    
  
    
}

