//
//  ModalExpenseIcoCo.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 16/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalExpenseIcoCoView: UIView , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    
    var returnDataExpenses : ((String) -> ())?
    var data = Array<Any>()
    var controller : ModalExpenseIcoCoController?
    
    override func awakeFromNib() {
        
       // fillData()
        controller = ModalExpenseIcoCoController(view:self)
        self.layer.cornerRadius = self.frame.size.height / 32
        contentView.layer.cornerRadius = contentView.frame.size.height / 32
        collectionView.layer.cornerRadius = contentView.frame.size.height / 32
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ExpenseIcoCoCell", bundle: nil), forCellWithReuseIdentifier: "cellItem")
        self.collectionView.register(UINib(nibName: "ExpenseIcoCell", bundle: nil), forCellWithReuseIdentifier: "cellIcoItem")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       
    }
    
    func fillData(colorMode: Bool){
        controller?.modeChange(mode:colorMode)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (controller?.numberOfItem(data: data))!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return controller!.cellForRow(collection:collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return controller!.calculateWith(width:self.frame.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  controller!.giveColor(collection: collectionView, indexPath: indexPath)
       
        controller?.touchCell(collection: collectionView, indexPath: indexPath)
        
    }
    
  
}
