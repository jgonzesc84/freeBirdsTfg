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
        
        let numbOfItems = 0
        if (collectionView == requestView?.supViewCollection) {
            
        }else{
            
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
    
}
