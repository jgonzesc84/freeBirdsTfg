//
//  ModalExpenseIcoCo.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 16/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalExpenseIcoCoView: UIView , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    var data = Array<UIColor>()
    
    override func awakeFromNib() {
        fillData()
        contentView.layer.cornerRadius = contentView.frame.size.height / 32
        collectionView.layer.cornerRadius = contentView.frame.size.height / 32
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ExpenseIcoCoCell", bundle: nil), forCellWithReuseIdentifier: "cellItem")
    }
    
    func fillData(){
        colorExpense.allCases.forEach {
            data.append(UIColor().colorFromHex($0.rawValue))
            print("eo")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ExpenseIcoCoCell
        cell.setupCell(color: data[indexPath.row] )
        MainHelper.circleView(view: cell)
        return cell
    }
    
}
