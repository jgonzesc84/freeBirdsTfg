//
//  TFHouses.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class TFHouses: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchHouseButton: Button!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("HousesView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }




}
