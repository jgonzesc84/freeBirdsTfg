//
//  ExpenseIcoCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 24/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ExpenseIcoCell: UICollectionViewCell {

    @IBOutlet weak var imageIcoView: UIImageView!
    var pathImage: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(path: String){
        pathImage = path
        imageIcoView.image = UIImage(named: pathImage!)
    }
}
