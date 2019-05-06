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
    
    @IBOutlet weak var seacrhButton: UIButton!
    
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var photoRoomButton: Button!
    public var roomModel = ModelRoom()
    var returnDataCreateRoom: ((ModelRoom) -> ())?
    var returnDataEditRoom: ((ModelRoom) -> ())?
    var editMode : Bool?
    var searchSelection: Bool?
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
        MainHelper.theStyle(view: topView)
       
        modalAddRoomView.layer.cornerRadius = modalAddRoomView.frame.height / 32
        acceptButton.backgroundColor = .white
        MainHelper.circleView(view: seacrhButton)
        MainHelper.giveMeStyle(button: acceptButton)
        MainHelper.circleView(view: photoRoomButton)
        photoRoomButton.backgroundColor = UIColor .AppColor.Green.mindApp
        seacrhButton.backgroundColor = UIColor .AppColor.Gray.greyApp
        searchSelection = false
        
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
}
