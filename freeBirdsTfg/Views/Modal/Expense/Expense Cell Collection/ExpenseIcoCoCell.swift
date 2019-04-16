//
//  ExpenseIcoCoCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 16/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ExpenseIcoCoCell: UICollectionViewCell {

    
    
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
   
    
    func setupCell(color:UIColor){
   
      colorView.backgroundColor = color
    }
    

}
