//
//  ModalRequestHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ModalRequestHouse: UIView , UITextViewDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descritionTextView: UITextView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var heightDescriptionConstraint: NSLayoutConstraint!
    
    var controller : ModalRequestHouseController?
     var returnDataRequestHouse: ((String) -> ())?
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
    }
    
    
   
    
    func initView(){
        controller = ModalRequestHouseController(modalRequestHouse: self)
        MainHelper.theStyle(view:mainView)
        titleLabel.textColor = UIColor .AppColor.Green.greenDinosaur
        titleLabel.text = "Mensaje de solicitud"
        MainHelper.circleButton(button: resetButton)
        mainView.layer.cornerRadius = mainView.frame.height / 32
        descritionTextView.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        controller?.autoSizeTextView(textView: textView)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return (controller?.allowmaxCharacter(textView:textView, text: text, range: range))!
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        
        controller?.resetButton()
    }
    
    
    @IBAction func acceptButton(_ sender: Any) {
        controller?.acceptButton()
    }

}
