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
    
    //MARK: atributes
    
    let modal : ModalMain?
    var modalCreateRoom : ModalCreateRoom?
    var modalCreateSection : ModalCreateSectionView?
    var modalCompleteHouse : ModalCompleteHouse?
    var modalRequestHouse : ModalRequestHouse?
    var modalExpenseIcoCo : ModalExpenseIcoCoView?
    var modalErrorText : ModalErrorText?
   
    init(ModalView: ModalMain!){
        modal = ModalView
        
    }
    //MARK: modal base methods
    
    func chargeViewModal(name : String){
        
        switch name {
        case "createRoom":
            modalCreateRoom = Bundle.main.loadNibNamed("ModalCreateRoom", owner: nil, options: nil)![0] as? ModalCreateRoom
            positionAndHeight(mainView: modal!, auxView: modalCreateRoom!, height: 0.6 , y: 1)
            modalCreateRoom!.editMode = false
            modalCreateRoom?.returnDataCreateRoom = { (model) -> () in
                self.modal?.returnData?(model)
                self.modal?.removeFromSuperview()
            }
            modalCreateRoom?.showPicker = { (picker,true) -> () in
                self.modal?.showPicker?(picker, true)
                //poner atras?
            }
            modalCreateRoom?.showPickerAlert = { (picker,true) -> () in
                self.modal?.showPickerAlert?(picker, true)
                //poner atras?
            }
            break
        case "editRoom":
            modalCreateRoom = Bundle.main.loadNibNamed("ModalCreateRoom", owner: nil, options: nil)![0] as? ModalCreateRoom
            positionAndHeight(mainView: modal!, auxView: modalCreateRoom!, height: 0.6 , y: 1)
            modalCreateRoom!.editMode = true
            modalCreateRoom?.returnDataEditRoom = { (model) -> () in
                self.modal?.returnEditData!(model)
                self.modal?.removeFromSuperview()
            }
            modalCreateRoom?.showPicker = { (picker,true) -> () in
                self.modal?.showPicker?(picker, true)
                //poner atras?
            }
            modalCreateRoom?.showPickerAlert = { (picker,true) -> () in
                self.modal?.showPickerAlert?(picker, true)
                //poner atras?
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
            modalCreateSection?.showPicker = { (picker,true) -> () in
                self.modal?.showPicker?(picker, true)
                //poner atras?
            }
            modalCreateSection?.showPickerAlert = { (picker,true) -> () in
                self.modal?.showPickerAlert?(picker, true)
                //poner atras?
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
            modalCreateSection?.showPicker = { (picker,true) -> () in
                self.modal?.showPicker?(picker, true)
                //poner atras?
            }
            modalCreateSection?.showPickerAlert = { (picker,true) -> () in
                self.modal?.showPickerAlert?(picker, true)
                //poner atras?
            }
            
            break
        case "completeHouse":
            modalCompleteHouse = Bundle.main.loadNibNamed("ModalCompleteHouse", owner: nil, options: nil)![0] as? ModalCompleteHouse
            positionAndHeight(mainView: modal!, auxView: modalCompleteHouse!, height: 0.65 , y: 0.9)
            modalCompleteHouse?.returnDataCompleteHouse = { (text) -> () in
                self.modal?.returnCompleteHouseData?(text)
                self.modal?.removeFromSuperview()
            }
            
            break
            
        case "requestHouse":
            modalRequestHouse = Bundle.main.loadNibNamed("ModalRequestHouse", owner: nil, options: nil)![0] as? ModalRequestHouse
            positionAndHeight(mainView: modal!, auxView: modalRequestHouse!, height: 0.4, y: 0.9)
            modalRequestHouse?.returnDataRequestHouse = { (text) -> () in
                self.modal?.returnRequestHouseData?(text as! String)
               // self.modal?.removeFromSuperview()
            }
            break
            
        case "addExpenseColor":
            modalExpenseIcoCo = Bundle.main.loadNibNamed("ModalExpenseIcoCoView", owner: nil, options: nil)![0] as? ModalExpenseIcoCoView
            modalExpenseIcoCo?.fillData(colorMode: true)
            positionAndHeight(mainView: modal!, auxView: modalExpenseIcoCo!, height: 0.6, y: 0.9)
            modalExpenseIcoCo?.returnDataExpenses = { (data) -> () in
                self.modal?.returnExpenseColour?(data)
               
            }
            break
        case "addExpenseIco":
            modalExpenseIcoCo = Bundle.main.loadNibNamed("ModalExpenseIcoCoView", owner: nil, options: nil)![0] as? ModalExpenseIcoCoView
            modalExpenseIcoCo?.fillData(colorMode: false)
            positionAndHeight(mainView: modal!, auxView: modalExpenseIcoCo!, height: 0.6, y: 0.9)
            modalExpenseIcoCo?.returnDataExpenses = { (data) -> () in
                self.modal?.returnExpenseIco?(data)
                
            }
            break
        case "errorText":
            modalErrorText = Bundle.main.loadNibNamed("ModalErrorText", owner: nil, options: nil)![0] as? ModalErrorText
            positionAndHeight(mainView: modal!, auxView: modalErrorText!, height: 0.15 , y: 0.6)
            
            break
            
        default:
            
            break
        }
    }
    
    func fillModal(model:Any){
        switch model {
        case is ModelRoom:
            
            let room = model as! ModelRoom
            if(room.user != nil){
              modalCreateRoom?.model = room
            }
            if let imageData = room.imageData{
               modalCreateRoom!.roomImageView.image = imageData
            }
            if let user = room.user{
               if let alias = user.alias{
                if alias.count > 0{
                    modalCreateRoom!.userTextEdit.isHidden = false
                    modalCreateRoom!.userTextEdit.isEnabled = false
                    modalCreateRoom!.seacrhButton.isEnabled = false
                    modalCreateRoom!.userTextEdit.text = user.alias
                    ImageManager.shared.checkUserImage(user){(model, match) in
                        if (match){
                            let image = model.imageData?.resizeImage(targetSize: self.modalCreateRoom!.userImageView.frame.size)
                            self.modalCreateRoom!.userImageView.isHidden = false
                            self.modalCreateRoom!.userImageView.clipsToBounds = true
                            self.modalCreateRoom!.userImageView.image = image
                        }else{
                            
                        }
                    }
                }
                }
               
            }
           
            modalCreateRoom!.priceTextEdit.text = room.price
            modalCreateRoom!.setupSelection(room.search!)
            //falta img
            break;
        case is ModelHouseSection:
            
            let section = model as! ModelHouseSection
            if let imageData = section.imageData{
                modalCreateSection!.sectiomRoomImage.image = imageData
            }
           // modalCreateSection!.oldPath = section.image
            modalCreateSection!.titleSectionTextField.text = section.title
            modalCreateSection!.descriptionSectionTextField.text = section.description
            //falta img
            
            break;
        default:
            break
        }
    }
    
    func loadError(text : String){
        modalErrorText?.setText(text:  text)
    }
    
    //MARK: private methods
    
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
