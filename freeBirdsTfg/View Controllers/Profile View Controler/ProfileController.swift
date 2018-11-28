//
//  ProfileController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class ProfileController{
    
     //MARK: atributes
    
    let profileView : ProfileViewController?
    
     //MARK: init
    
    init(profileView: ProfileViewController!){
        
        self.profileView = profileView
     
    }
    
      //MARK: table view delegate methods
    
    func drawCell(tableView: UITableView, indexPath: IndexPath) -> (UITableViewCell){
    
        let cell : ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! ProfileTableViewCell
        fillCell(row: indexPath.row, cell: cell)
        return cell
    }
    
    //MARK: private methods
    func fillCell(row: Int, cell: ProfileTableViewCell){
        
        switch row {
        case 0:
            cell.titleLabel.text = "Número de Telefono"
            break
        case 1:
            cell.titleLabel.text = "Cuenta"
            break
        case 2:
            cell.titleLabel.text = "Contraseña"
            break
        default:
            break
        }
    }
    
}
