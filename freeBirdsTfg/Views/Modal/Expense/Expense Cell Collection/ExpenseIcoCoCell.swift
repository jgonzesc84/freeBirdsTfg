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
    var pathColor: String?
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
   
    
    func setupCell(path:String){
      pathColor = path
      colorView.backgroundColor = UIColor().colorFromHex(path)
    }
    
    func white(){
        colorView.backgroundColor = UIColor .white
    }

}
