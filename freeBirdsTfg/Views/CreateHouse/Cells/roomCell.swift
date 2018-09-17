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
        self.selectionStyle = UITableViewCellSelectionStyle.none
        MainHelper.theStyle(view: addView)
        MainHelper.theStyle(view: roomView)
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        //roomImageView.layer.cornerRadius = roomImageView.frame.size.width/4
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addView.isHidden = false
        roomView.isHidden = true
        
    }
    
   public func setup(room: ModelRoom?){
        if (room != nil){
        userlabel.text = room?.user
        priceLabel.text = room?.price
        addView.isHidden = true
        roomView.isHidden = false
        //Imagen? guardar en otra parte para no llamar todo el rato al servicio??
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

