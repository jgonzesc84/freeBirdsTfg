//
//  ModalCreateRoom.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ModalCreateRoom: UIView {

     //MARK: atributes and outlets
    
    @IBOutlet weak var userTextEdit: UITextField!
    @IBOutlet weak var priceTextEdit: UITextField!
    @IBOutlet weak var modalAddRoomView: UIView!
    @IBOutlet weak var acceptButton: Button!
    
    public var roomModel = ModelRoom()
    var returnDataCreateRoom: ((ModelRoom) -> ())?
    var returnDataEditRoom: ((ModelRoom) -> ())?
    var editMode : Bool?
    
    var controller : ModalCreateRoomController?
    
    //MARK: cycle life methods
    
    override func awakeFromNib() {
        super .awakeFromNib()
       initView()
    }
    
     //MARK:init view
    
    func initView(){
        controller  = ModalCreateRoomController(modalCreateRoom: self)
        self.hideKeyboardWhenTappedAround()
        MainHelper.theStyle(view: self.modalAddRoomView)
        modalAddRoomView.layer.cornerRadius = modalAddRoomView.frame.height / 32
    }
   
      //MARK:action button view
    
    @IBAction func acceptAction(_ sender: Any) {
        
      controller?.acceptButton()
    }
}
