//
//  ModalMain.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 8/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material


class ModalMain: UIView {
    
   
    @IBOutlet weak var backView: UIView!
   
    var controller : ModalController?
    
    //public var mode = true
    public var returnData: ((Any) -> ())?
    public var returnEditData: ((Any) -> ())?
    public var returnCompleteHouseData: ((String) -> ())?
   // public var editeMode : Bool!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        controller = ModalController(ModalView: self)
    }
    
    func loadContentView(name : String){
         controller!.chargeViewModal(name : name)
         dismissViewSetup()
    }
    
    
    public func fillModal(model:Any){
        controller!.fillModal(model: model)

    }
    
    func dismissViewSetup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        backView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
  
}
