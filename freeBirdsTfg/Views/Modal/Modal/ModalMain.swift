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
    
    //MARK: atributes and outlets
    
    var controller : ModalController?
    
    //public var mode = true
    public var returnData: ((Any) -> ())?
    public var returnEditData: ((Any) -> ())?
    public var returnCompleteHouseData: ((String) -> ())?
    public var returnRequestHouseData: ((String) -> ())?
    public var returnExpenseColour: ((String) -> ())?
    public var returnExpenseIco: ((String) -> ())?
    // public var editeMode : Bool!
    
    //MARK: cycle life methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        controller = ModalController(ModalView: self)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.frame = frame
        MainHelper.theStyle(view: self)
    }
    
    //MARK: modal base methods
    
    func loadContentView(name : String){
        controller!.chargeViewModal(name : name)
        dismissViewSetup()
    }
    
    
    public func fillModal(model:Any){
        controller!.fillModal(model: model)
        
    }
    func loadError(text: String){
        controller!.loadError(text : text)
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
