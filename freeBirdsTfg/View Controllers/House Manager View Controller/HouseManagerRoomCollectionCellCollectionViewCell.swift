//
//  HouseManagerRoomCollectionCellCollectionViewCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 11/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

protocol cellInsertUserHouse {
    func refreshCollection(succes: Bool, atRow: IndexPath)
}
class HouseManagerRoomCollectionCellCollectionViewCell: UICollectionViewCell {
  
    

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var acceptButtom: Button!
    var user = ModelUser()
    var owner = false
    var room : ModelRoom?
    var userHaveRoom : Bool?
    var delegate : cellInsertUserHouse?
    var row: IndexPath?
    override func awakeFromNib() {
       super.awakeFromNib()
      setupView()
    }
    func setupView(){
      
        MainHelper.theStyle(view: topView)
        MainHelper.theStyle(view: bottomView)
    }
    func setupCell( _ model: ModelRoom, atRow: IndexPath){
        room = model
        row = atRow
        priceTextField.text = model.price
        if model.user != nil{
            if( model.user!.idUser != nil && model.user!.idUser!.count > 0){
                userNameLabel.text = model.user?.alias
                self.user = model.user!
                //userImageView.image = user.image
                configureButton(isEmpty: false)
            }else{
                configureButton(isEmpty: true)
            }
        }else{
             configureButton(isEmpty: true)
        }
        
       // roomImageView.image = model.image
    }
    
    func resetCell(){
        MainHelper.enabledButton(button:acceptButtom)
        acceptButtom.setTitle("Entrar", for: .normal)
        userNameLabel.text = ""
    }
    
    @IBAction func acceptAction(_ sender: Any) {
         let manager = EditRoomUserManager()
        if(acceptButtom.titleLabel!.text == "Entrar"){
            manager.enterUserRoom(idRoom: room!.idRoom! , user: BaseManager().getUserDefault()){
                (success) in
                    self.delegate?.refreshCollection(succes: success, atRow: self.row!)
            }
        }else{
            manager.exitUserRoom(idRoom: room!.idRoom!,user: BaseManager().getUserDefault()){
                (success) in
               self.delegate?.refreshCollection(succes: success, atRow: self.row!)
            }
        }
    }
    
  
    func configureButton( isEmpty: Bool){
        if(isEmpty && !userHaveRoom!){
            acceptButtom.setTitle("Entrar", for: .normal)
        }else{
            if(owner){
                acceptButtom.setTitle("Salir", for: .normal)
            }else{
                MainHelper.dissableButton(button: acceptButtom)
            }
            
        }
    }
}
