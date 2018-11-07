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
    var showRoom : Bool?
    
    init(requestView: HouseDetailRequestViewController!){
        
        self.requestView = requestView
        showRoom = true
    }
    
    func numberOfItemsInSection(collectionView: UICollectionView ) -> Int{
        
        var numbOfItems = 0
        if(requestView!.house?.section?.count == 0){
            requestView!.infView.translatesAutoresizingMaskIntoConstraints = false
            requestView!.supView.translatesAutoresizingMaskIntoConstraints  = false
            requestView!.infView.isHidden = true
            let heightConstraint = NSLayoutConstraint(item: requestView!.infView, attribute: .height, relatedBy: .equal,
                                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
            let bottonConstraint = NSLayoutConstraint(item: requestView!.supView, attribute: .bottom, relatedBy: .equal,
                                                      toItem: requestView!.footerview, attribute: .top, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate( [heightConstraint,bottonConstraint])
            requestView!.supViewCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            requestView!.view.layoutSubviews()
        }
        if(showRoom!){
            if (collectionView == requestView?.supViewCollection) {
                numbOfItems = requestView!.house?.listOfRoom?.count ?? 0
            }else{
                 numbOfItems = requestView!.house?.section?.count ?? 0
            }
        }else{
            if (collectionView == requestView?.supViewCollection) {
                numbOfItems = requestView!.house?.section?.count ?? 0
            }else{
                numbOfItems = requestView!.house?.listOfRoom?.count ?? 0
            }
        }
        return numbOfItems
    }
   
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
      
        
        if (collectionView == requestView?.supViewCollection) {
            let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "supCell", for: indexPath) as! supViewCollectionViewCell
            if(showRoom!){
                requestView!.supViewLabel.text = "Habitaciones"
                let model = requestView!.house?.listOfRoom![indexPath.row]
                cell.setupCell(model: model! )
                
            }else{
                requestView!.supViewLabel.text = "Secciones"
                let model = requestView!.house?.section![indexPath.row]
                cell.setupCell(model: model! )
            }
            return cell
        }else{
            let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "infCell", for: indexPath) as! infViewCollectionViewCell
            if(showRoom!){
                requestView!.infViewLabel.text = "Secciones"
            }else{
                 requestView!.infViewLabel.text = "Habitaciones"
            }
            return cell
        }
        
     
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
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath){
        
        if (collectionView == requestView?.supViewCollection) {
           
        }else{
            changeDataView(show: showRoom!)
        }
    }
    
    func changeDataView(show : Bool){
        
        if(show){
            UIView.transition(with:  (requestView?.infViewCollection)!,
                              duration: 1,
                              options: .transitionCurlUp,
                              animations: {   self.requestView?.infViewCollection.reloadData() })
            UIView.transition(with:  (requestView?.supViewCollection)!,
                              duration: 1,
                              options: .transitionCurlDown,
                              animations: {   self.requestView?.supViewCollection.reloadData() })
            showRoom = false
            
        }else{
            UIView.transition(with:  (requestView?.infViewCollection)!,
                              duration: 1,
                              options: .transitionFlipFromBottom,
                              animations: {   self.requestView?.infViewCollection.reloadData() })
            UIView.transition(with:  (requestView?.supViewCollection)!,
                              duration: 1,
                              options: .transitionCurlUp,
                              animations: {   self.requestView?.supViewCollection.reloadData() })
            showRoom = true
        }
    }
    
}
