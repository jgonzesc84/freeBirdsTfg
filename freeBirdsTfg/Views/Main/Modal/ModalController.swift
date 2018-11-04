//
//  ModalController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit
class ModalController{
    
   let modal : ModalMain?
    var modalCreateRoom : ModalCreateRoom?
    var modalCreateSection : ModalCreateSectionView?
    
    init(ModalView: ModalMain!){
        modal = ModalView
    
    }
    
    func chargeViewModal(name : String){
        
        switch name {
        case "createRoom":
            modalCreateRoom = Bundle.main.loadNibNamed("ModalCreateRoom", owner: nil, options: nil)![0] as? ModalCreateRoom
            positionAndHeight(mainView: modal!, auxView: modalCreateRoom!, height: 0.5 , y: 0.8)
            modalCreateRoom!.editMode = false
            modalCreateRoom?.returnDataCreateRoom = { (model) -> () in
            self.modal?.returnData?(model)
            self.modal?.removeFromSuperview()
            }
            break
        case "editRoom":
            modalCreateRoom = Bundle.main.loadNibNamed("ModalCreateRoom", owner: nil, options: nil)![0] as? ModalCreateRoom
            positionAndHeight(mainView: modal!, auxView: modalCreateRoom!, height: 0.5 , y: 0.8)
            modalCreateRoom!.editMode = true
            modalCreateRoom?.returnDataEditRoom = { (model) -> () in
                self.modal?.returnEditData!(model)
                self.modal?.removeFromSuperview()
            }
            break
        case "createSection":
            modalCreateSection = Bundle.main.loadNibNamed("ModalCreateSectionView", owner: nil, options: nil)![0] as? ModalCreateSectionView
            positionAndHeight(mainView: modal!, auxView: modalCreateSection!, height: 0.65 , y: 0.9)
            modalCreateSection!.editMode = false
            modalCreateSection?.returnDataCreateSection = { (model) -> () in
            self.modal?.returnData?(model)
            self.modal?.removeFromSuperview()
            }
            break
        case "editSection":
            modalCreateSection = Bundle.main.loadNibNamed("ModalCreateSectionView", owner: nil, options: nil)![0] as? ModalCreateSectionView
            positionAndHeight(mainView: modal!, auxView: modalCreateSection!, height: 0.65 , y: 0.9)
            modalCreateSection!.editMode = true
            modalCreateSection?.returnDataEditSection = { (model) -> () in
                self.modal?.returnEditData?(model)
                self.modal?.removeFromSuperview()
            }
            
            break
        case "completeHouse":
            
            
            break
        default:
            
            break
        }
    }
    
    func fillModal(model:Any){
        switch model {
        case is ModelRoom:
            
            let room = model as! ModelRoom
            modalCreateRoom!.userTextEdit.text = room.user
            modalCreateRoom!.priceTextEdit.text = room.price
            //falta img
            break;
        case is ModelHouseSection:
            
            let section = model as! ModelHouseSection
            modalCreateSection!.titleSectionTextField.text = section.title
            modalCreateSection!.descriptionSectionTextField.text = section.description
            //falta img
            
            break;
        default:
            break
        }
    }
    
    func positionAndHeight(mainView:UIView , auxView:UIView, height : Float , y: Float){
        auxView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview( auxView)
        let widthConstraint = NSLayoutConstraint(item: auxView, attribute: .width, relatedBy: .equal,
                                                 toItem: mainView, attribute: .width, multiplier: 0.9, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: auxView, attribute: .height, relatedBy: .equal,
                                                  toItem: mainView, attribute: .height, multiplier: CGFloat(height), constant: 0)
        
        let xConstraint = NSLayoutConstraint(item: auxView, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: auxView, attribute: .centerY, relatedBy: .equal, toItem:mainView, attribute: .centerY, multiplier: CGFloat(y), constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        mainView.layoutSubviews()
    }
    
    
}
