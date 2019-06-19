//
//  ModalCreateRoom.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 03/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ModalCreateRoom: UIView, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     //MARK: atributes and outlets
    
    @IBOutlet weak var userTextEdit: UITextField!
    @IBOutlet weak var priceTextEdit: UITextField!
    @IBOutlet weak var modalAddRoomView: UIView!
    @IBOutlet weak var acceptButton: Button!
    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var seacrhButton: UIButton!
    
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var photoRoomButton: Button!
    public var roomModel = ModelRoom()
    var returnDataCreateRoom: ((ModelRoom) -> ())?
    var returnDataEditRoom: ((ModelRoom) -> ())?
    var showPicker: ((UIImagePickerController, Bool) -> ())?
    var showPickerAlert:((UIAlertController,Bool) -> ())?
    
    
    var editMode : Bool?
    var searchSelection: Bool?
    var controller : ModalCreateRoomController?
    var model:ModelRoom?
     var imagePicker = UIImagePickerController()
    //MARK: cycle life methods
    
    override func awakeFromNib() {
        super .awakeFromNib()
       initView()
    }
    
     //MARK:init view
    
    func initView(){
        controller  = ModalCreateRoomController(modalCreateRoom: self)
        userTextEdit.isHidden = true
        self.hideKeyboardWhenTappedAround()
        MainHelper.theStyle(view: topView)
       
        modalAddRoomView.layer.cornerRadius = modalAddRoomView.frame.height / 32
        acceptButton.backgroundColor = .white
        MainHelper.circleView(view: seacrhButton)
        MainHelper.giveMeStyle(button: acceptButton)
        MainHelper.circleView(view: photoRoomButton)
        photoRoomButton.backgroundColor = UIColor .AppColor.Green.mindApp
        seacrhButton.backgroundColor = UIColor .AppColor.Gray.greyApp
        searchSelection = false
         imagePicker.delegate = self
        
    }
    func setupSelection(_ selection: Bool){
        searchSelection = selection
       self.seacrhButton.backgroundColor = searchSelection! ?   UIColor .AppColor.Green.mindApp : UIColor .AppColor.Gray.greyApp
    }
      //MARK:action button view
    
    @IBAction func searchViewAction(_ sender: Any) {
          UIView.animate(withDuration: 0.15) {
           self.changeSelection()
            
        }
        
        
    }
    
    func changeSelection(){
        
        self.seacrhButton.backgroundColor = searchSelection! ?   UIColor .AppColor.Gray.greyApp : UIColor .AppColor.Green.mindApp
        searchSelection = searchSelection! ? false : true
       
    }
    @IBAction func acceptAction(_ sender: Any) {
        
      controller?.acceptButton()
    }
    
    @IBAction func photoAction(_ sender: Any) {
        
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
            roomImageView.contentMode = .scaleToFill
            let imageResizable = pickedImage.resizeImage(targetSize: roomImageView!.frame.size)
            roomImageView.image = imageResizable
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
