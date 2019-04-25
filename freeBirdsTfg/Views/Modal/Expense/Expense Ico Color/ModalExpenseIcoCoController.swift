//
//  ModalExpenseIcoCoController.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 16/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

protocol valueReturn {
    func giveColor(_ color:UIColor)
}

class ModalExpenseIcoCoController{
    
    var modal : ModalExpenseIcoCoView?
    let estimatedWitdh = 75
    let cellMargin = 20
    var mode : Bool?
    
    
    init(view: ModalExpenseIcoCoView){
        self.modal = view
    }
    
    func numberOfItem(data: Array<Any>)-> Int{
     return data.count
    }
    func modeChange(mode:Bool){
        self.mode = mode
        if(mode){
            colorExpense.allCases.forEach {
                modal!.data.append($0.rawValue)
            }
        }else{
            icoExpense.allCases.forEach {
                modal!.data.append($0.rawValue)
            }
        }
    }
    
    func cellForRow(collection: UICollectionView , indexPath:IndexPath) -> UICollectionViewCell{
        
        return mode! ? setCellColor(collection: collection, indexPath: indexPath) : setCellIco(collection:collection, indexPath:indexPath)
        
    }
    

    func setCellColor(collection:UICollectionView ,indexPath:IndexPath) -> UICollectionViewCell{
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ExpenseIcoCoCell
        cell.setupCell(path: modal!.data[indexPath.row] as! String)
        MainHelper.circleView(view: cell)
        return cell
    }
    
    func setCellIco(collection:UICollectionView ,indexPath:IndexPath) -> UICollectionViewCell{
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cellIcoItem", for: indexPath) as! ExpenseIcoCell
        cell.setupCell(path: modal!.data[indexPath.row] as! String)
        MainHelper.circleView(view: cell)
        return cell
    }
    
    func calculateWith(width:CGFloat)->CGSize{
        let estimateedWith = CGFloat(estimatedWitdh)
        let cellCount = floor(CGFloat(width / estimateedWith))
        let margin = CGFloat(cellMargin * 2 )
        let totalWidth = (width - CGFloat(cellMargin) * (cellCount - 1 ) - margin ) / cellCount
        let value = CGSize(width: totalWidth, height: totalWidth)
        return value
    }
    
    
    func touchCell(collection: UICollectionView , indexPath:IndexPath){
        mode! ? clearAllColor(collection: collection, indexPath: indexPath) : clearAllIco(collection: collection, indexPath: indexPath)
    }
    
    func clearAllColor(collection: UICollectionView, indexPath: IndexPath){
        let cell = collection.cellForItem(at: indexPath) as! ExpenseIcoCoCell
        let allCell = modal!.collectionView.visibleCells
        for case let item as ExpenseIcoCoCell in allCell  {
            UIView.animate(withDuration: 0.25
                , animations: {
                    item.white()
                    collection.layoutIfNeeded()
            }) { (finished: Bool) in
                self.modal!.returnDataExpenses?(cell.pathColor!)
            }
        }
        
    }
    
    func clearAllIco(collection:UICollectionView, indexPath: IndexPath){
        let cell = collection.cellForItem(at: indexPath) as! ExpenseIcoCell
        let path = cell.pathImage
         self.modal!.returnDataExpenses?(path!)
    }
}
