//
//  HouseDetailRequestController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit
class HouseDetailRequestController{
    
    let requestView : HouseDetailRequestViewController?
    
    init(requestView: HouseDetailRequestViewController!){
        
        self.requestView = requestView
        
    }
    
    func numberOfItemsInSection(collectionView: UICollectionView ) -> Int{
        
        var numbOfItems = 0
        if (collectionView == requestView?.supViewCollection) {
            numbOfItems = requestView!.house?.listOfRoom?.count ?? 0
        }else{
            numbOfItems = requestView!.house?.section?.count ?? 0
            if(numbOfItems == 0){
                requestView!.infView.isHidden = true
            }
        }
        
        return numbOfItems
    }
   
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        var cell = UICollectionViewCell()
        
        if (collectionView == requestView?.supViewCollection) {
              cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "supCell", for: indexPath) as! supViewCollectionViewCell
            
        }else{
              cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "infCell", for: indexPath) as! infViewCollectionViewCell
        }
        
        return cell
    }
    
    func calculateItemSize(collectionView: UICollectionView){
        
        var cellScaling: CGFloat = 0.0
        let parentSize = collectionView.frame
        if(collectionView == requestView?.supViewCollection){
            cellScaling = 0.9
        }else{
             cellScaling = 0.9
            
        }
        var cellWidth = floor(parentSize.width * cellScaling)
        let cellHeight = floor(parentSize.height * cellScaling)
        if(collectionView == requestView?.infViewCollection){
            cellWidth = cellWidth / 2
        }
        let insetX = (parentSize.width - cellWidth) / 2.0
       // let insetY  = (parentSize.height - cellHeight) / 2.0
        let insetY  = 0.00
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: CGFloat(insetY), left: insetX, bottom: CGFloat(insetY), right: insetX)
    }
    
}
