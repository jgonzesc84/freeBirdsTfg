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
    
    //  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    func sizeForItemAt(collectionView: UICollectionView, collectionViewlayout: UICollectionViewLayout , indexPath: IndexPath) -> CGSize{
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left * 2
        cellSize.width -= collectionView.contentInset.right * 2
        cellSize.height = cellSize.width

        return cellSize
    }
    
    func updateCellsLayout(collectionView:UICollectionView)  {
        
        let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width)/2
        
        for cell in collectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / ((requestView?.view.bounds.width)! * 2.7)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
}
