//
//  ModalCompleteHouse.swift
//  freeBirdsTfg
//
//  Created by Javier on 22/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class ModalCompleteHouse: UIView , UITextViewDelegate{
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descritionTextView: UITextView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var heightDescriptionConstraint: NSLayoutConstraint!
    
    var controller : ModalCompleteHouseController?
    var returnDataCompleteHouse: ((String) -> ())?
    
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
    }
    
    func initView(){
        controller = ModalCompleteHouseController(modalCompleteHouse: self)
        MainHelper.theStyle(view:mainView)
        //titleLabel.font = UIFont .AppFont.titleFont.titleFont
        titleLabel.textColor = UIColor .AppColor.Green.greenDinosaur
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
