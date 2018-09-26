//
//  addRoomModalView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 8/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
class addRoomModalView: UIView {
     //addRoomOutlets
    @IBOutlet weak var userTextEdit: UITextField!
    @IBOutlet weak var priceTextEdit: UITextField!
    @IBOutlet weak var modalAddRoomView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var priceSlider: UISlider!
    public var roomModel = ModelRoom()
    //addSectionOutlets
    @IBOutlet weak var ModalAddRoom: UIView!
    
    @IBOutlet weak var modalAddSectionView: UIView!
    @IBOutlet weak var titleSectionTextField: UITextField!
    @IBOutlet weak var descriptionSectionTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var sectiomRoomImage: UIImageView!
    @IBOutlet weak var acceptSectionButton: UIButton!
    public var sectionModel = ModelHouseSection ()
    
    //clousure methods
    public var mode = true
    public var returnData: ((Any) -> ())?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        modalAddSectionView.isHidden = true
        modalAddRoomView.isHidden = true
        //commonInit()
    }
    func mockuP(){
        if(mode){
            
            userTextEdit.text = "UsuarioPrueba"
            priceTextEdit.text = "100"
        }else{
        
           /* titleSectionTextField.text = "cocina"
            descriptionSectionTextField.text = "Limpia cuadros de baños cosa bonita, dos neveras iluminada abierta con vitroceramica"*/
        }
      
    }
    
    public func setupModal(mode : Bool){
        self.mode = mode
        if (mode){
            modalAddRoomView.isHidden = false
            self.hideKeyboardWhenTappedAround()
            MainHelper.theStyle(view: self.modalAddRoomView)
            modalAddRoomView.layer.cornerRadius = modalAddRoomView.frame.height / 32
            mockuP()
        }else{
            self.hideKeyboardWhenTappedAround()
            modalAddSectionView.isHidden = false
            modalAddSectionView.layer.cornerRadius = modalAddSectionView.frame.height / 32
            MainHelper.theStyle(view: self.modalAddSectionView)
            cameraButton.layer.cornerRadius = cameraButton.frame.size.width / 4
            titleSectionTextField.placeholder = "Introduzca el nombre de la seccion"
            descriptionSectionTextField.placeholder = "Haz un pequeña descripción si quieres.."
            mockuP()
        }
        
         dismissViewSetup()
       
}
    
    func dismissViewSetup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        backView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if (mode == true){
            roomModel.price = priceTextEdit.text!
            roomModel.user = userTextEdit.text!
            returnData?(roomModel)
            removeFromSuperview()
        }else{
            sectionModel.title = titleSectionTextField.text
            sectionModel.description = descriptionSectionTextField.text
            returnData?(sectionModel)
            removeFromSuperview()
        }
        
        
        
    }
}
