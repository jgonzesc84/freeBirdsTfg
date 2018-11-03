//
//  CreateSectionView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalCreateSectionView: UIView {

   
    @IBOutlet weak var modalAddSectionView: UIView!
    @IBOutlet weak var titleSectionTextField: UITextField!
    @IBOutlet weak var descriptionSectionTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var sectiomRoomImage: UIImageView!
    @IBOutlet weak var acceptSectionButton: UIButton!
    
     var controller : ModalCreateSectionController?
      var returnDataCreateSection: ((ModelHouseSection) -> ())?
    
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
        controller = ModalCreateSectionController(modalCreateSection: self)
    }
    
    func initView(){
        self.hideKeyboardWhenTappedAround()
        MainHelper.theStyle(view: self.modalAddSectionView)
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height / 2
        modalAddSectionView.layer.cornerRadius = modalAddSectionView.frame.height / 32
    }
    
    
    @IBAction func aceptButton(_ sender: Any) {
        controller?.acceptButton()
      
    }
    
}
