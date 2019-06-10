//
//  CreateSectionView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ModalCreateSectionView: UIView, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: atributes and outlets
    
    @IBOutlet weak var modalAddSectionView: UIView!
    @IBOutlet weak var titleSectionTextField: UITextField!
    @IBOutlet weak var descriptionSectionTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var sectiomRoomImage: UIImageView!
    @IBOutlet weak var acceptSectionButton: UIButton!
    
    var controller : ModalCreateSectionController?
    var editMode : Bool?
    var imagePicker = UIImagePickerController()
    var returnDataCreateSection: ((ModelHouseSection) -> ())?
    var returnDataEditSection: ((ModelHouseSection) -> ())?
   
    var showPicker: ((UIImagePickerController, Bool) -> ())?
    var showPickerAlert:((UIAlertController,Bool) -> ())?
    
    //MARK: cycle life methods
    
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
        controller = ModalCreateSectionController(modalCreateSection: self)
    }
    
    //MARK: setup view methods
    
    func initView(){
        self.hideKeyboardWhenTappedAround()
        MainHelper.theStyle(view: self.modalAddSectionView)
        self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height / 2
        modalAddSectionView.layer.cornerRadius = modalAddSectionView.frame.height / 32
        imagePicker.delegate = self
    }
    
    //MARK: action button methods
    
    @IBAction func aceptButton(_ sender: Any) {
        controller?.acceptButton()
    }
    
    @IBAction func takeImageAction(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
      alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        if (showPickerAlert != nil){
          showPickerAlert!(alert,true)
        }
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            if(showPicker != nil){
                showPicker!(imagePicker,true)
            }
            
            
         //   self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if (showPickerAlert != nil){
                showPickerAlert!(alert,true)
            }
           // self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        if(showPicker != nil){
            showPicker!(imagePicker,true)
        }
       // self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            sectiomRoomImage.contentMode = .scaleToFill
            let imageResizable = pickedImage.resizeImage(targetSize: sectiomRoomImage!.frame.size)
            sectiomRoomImage.image = imageResizable
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

