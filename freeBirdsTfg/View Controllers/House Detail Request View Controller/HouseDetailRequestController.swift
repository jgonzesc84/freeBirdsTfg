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
    
    //MARK: atributes
    
    let requestView : HouseDetailRequestViewController?
    var showRoom : Bool?
    
    //MARK: init
    
    init(requestView: HouseDetailRequestViewController!){
        
        self.requestView = requestView
        showRoom = true
    }
    
    //MARK: collection view delegates
    
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
            requestView!.supViewCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
                let model = requestView!.house?.section![indexPath.row]
                cell.setupCell(model: model! )
            }else{
                requestView!.infViewLabel.text = "Habitaciones"
                let model = requestView!.house?.listOfRoom![indexPath.row]
                cell.setupCell(model: model! )
            }
            return cell
        }
        
        
    }
    
    
    
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath){
        
        if (collectionView == requestView?.supViewCollection) {
            
        }else{
            changeDataView(show: showRoom!)
        }
    }
    
    
    
    //MARK: modal view methods
    
    func requestAction(){
        prepareModal(name:"requestHouse")
    }
    
    func prepareModal(name : String){
        requestView?.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: nil, options: nil)![0] as? ModalMain
        requestView!.modalView?.loadContentView(name: name)
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.view.addSubview(requestView!.modalView!)
            requestView!.modalView?.returnRequestHouseData = { (text) -> () in
                let reqManager = RequestMessageManager()
                let model = reqManager.factory.createRequest(self.requestView!.house!,text)
                reqManager.insertRequest(model, completion: { (sucess) in
                    if(sucess){
                        self.requestView!.navigationController?.popViewController(animated: true)
                    }else{
                        print("fallo")
                    }
                })
            }
        }
    }
    
    //MARK: private methods
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
