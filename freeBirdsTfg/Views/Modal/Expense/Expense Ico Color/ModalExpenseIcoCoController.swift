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
    
    
    init(view: ModalExpenseIcoCoView){
        self.modal = view
    }
    
    func numberOfItem(data: Array<Any>)-> Int{
     return data.count
    }
    
    func cellForRow(collection: UICollectionView , indexPath:IndexPath) -> UICollectionViewCell{
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ExpenseIcoCoCell
        cell.setupCell(color: modal!.data[indexPath.row] )
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
    
    func giveColor(collection:UICollectionView, indexPath: IndexPath){
        let cell = collection.cellForItem(at: indexPath) as! ExpenseIcoCoCell
        let color = cell.colorView.backgroundColor
        modal!.returnDataExpenses?(color!)
    }
}
