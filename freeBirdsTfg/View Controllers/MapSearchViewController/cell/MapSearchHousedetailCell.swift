//
//  MapSearchHousedetailCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 15/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class MapSearchHousedetailCell: UITableViewCell {
 //MARK: atributes and outlets
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageRoomView: UIImageView!
    var controller : MapSearchHousedetailCellController?

     //MARK: cycle life methods
    override func awakeFromNib() {
        super.awakeFromNib()
        controller = MapSearchHousedetailCellController(cell:self)
        initView()
    }
    //MARK: setup view
    
    func initView(){
        MainHelper.giveMeStyle(label:priceLabel)
// view.layer.shadowRadius = 2
        priceLabel.font = UIFont .AppFont.titleFont.titleFontSolid
        priceLabel.textColor = UIColor .white
        imageRoomView.layer.cornerRadius = imageRoomView.frame.height / 4
        MainHelper.borderShadowRedonde(view: imageRoomView)
        self.selectionStyle = UITableViewCellSelectionStyle .none
    }
    
    //MARK: setup cell
    
    func configureCell(model: ModelRoom){
        controller?.setupCell(model:model)
        
    }
    
    func resetCell(){
        controller?.resetCell()
    }
    
}
