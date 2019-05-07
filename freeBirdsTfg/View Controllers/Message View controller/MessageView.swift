//
//  MessageView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class MessageView: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var inputKeyboardView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var inputKeyTextEdit: UITextField!
    
    
    
    
    var listOfMessage: Array<ModelRequestMessageHouse>?
    @IBOutlet weak var bottonInputkeyboardView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
         prepareNav(label: titleLabel, text: "Chat")
        setuptable()
        keyboardSetup()
        inputKeyTextEdit.font = UIFont .AppFont.middleFont.middlWord
        inputKeyboardView.layer.borderWidth = 1
        inputKeyboardView.layer.borderColor = UIColor .black.cgColor
    }
    
    func setuptable(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "cellItem")
        table.estimatedRowHeight = 100
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var numberItems = 0
        if let count = listOfMessage?.count{
            numberItems = count
        }
        return numberItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! MessageViewCell
        cell.setupCell(listOfMessage![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func keyboardSetup(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
       // NotificationCenter.defaultCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillhide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
       
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
           UIView.animate(withDuration: 1) {
            self.bottonInputkeyboardView.constant = keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillhide(_ notification: Notification) {
        UIView.animate(withDuration: 0.15) {
            self.bottonInputkeyboardView.constant = 0
        }
        
        
    }

}
