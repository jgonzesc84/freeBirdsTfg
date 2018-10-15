//
//  MapSearchHousedetailCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 15/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class MapSearchHousedetailCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageRoomView: UIImageView!
    var controller : MapSearchHousedetailCellController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        controller = MapSearchHousedetailCellController(cell:self)
        initView()
    }
    
    func initView(){
        MainHelper.giveMeStyle(label:priceLabel)
        imageRoomView.layer.cornerRadius = imageRoomView.frame.height / 4
        MainHelper.borderShadowRedonde(view: imageRoomView)
        self.selectionStyle = UITableViewCellSelectionStyle .none
    }
    
    func configureCell(model: ModelRoom){
        controller?.setupCell(model:model)
        
    }
    
    func resetCell(){
        controller?.resetCell()
    }
    
}
