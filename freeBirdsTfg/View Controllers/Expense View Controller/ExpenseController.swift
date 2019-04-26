//
//  ExpenseController.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class ExpenseController {
    
    var view : ExpenseView?
    
    init(view : ExpenseView){
        self.view = view;
    }
    
    func didSelectRow(tableView: UITableView, indexPath: IndexPath){
        
        let vc = AddExpenseView (nibName:"AddExpenseView", bundle: nil)
        vc.hidesBottomBarWhenPushed = true;
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func drawCell(tableView: UITableView, indexPath: IndexPath)-> UITableViewCell{
        let cell : AddExpenseCell = tableView.dequeueReusableCell(withIdentifier: "addExpense", for: indexPath) as! AddExpenseCell
        return cell
      
    }
}
