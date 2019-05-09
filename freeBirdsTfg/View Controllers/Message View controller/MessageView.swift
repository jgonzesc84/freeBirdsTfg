//
//  MessageView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class MessageView: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var inputKeyboardView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var inputKeyTextEdit: UITextField!
    
    @IBOutlet weak var inpuTextView: UITextView!
    
    @IBOutlet weak var addtextButton: Button!
      var placeholderLabel : UILabel!
    
    var request : ModelRequestHouse?
    var listOfMessage: Array<ModelRequestMessageHouse>?
   
    @IBOutlet weak var bottonInputkeyboardView: NSLayoutConstraint!
    @IBOutlet weak var bottonTable: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        prepareNav(label: titleLabel, text: "Chat")
        setuptable()
        keyboardSetup()
        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
         listenFirstTime()
        scrollToLastPosition()
    }
    func initView(){
        inpuTextView.delegate = self
        inpuTextView.text = ""
        makePlaceHolderOnTextView(inpuTextView)
        inpuTextView.font = UIFont .AppFont.middleFont.middlWord
        inpuTextView.textColor = .black
        addButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
        addButton.layer.cornerRadius = 5
        inputKeyboardView.layer.borderWidth = 1
        inputKeyboardView.layer.borderColor = UIColor .black.cgColor
        listenChildAdded()
        if(request?.state == constant.statcDeclineRequest){
            inputKeyboardView.backgroundColor = UIColor .AppColor.Gray.greyCancel
            inpuTextView.backgroundColor = UIColor .AppColor.Gray.greyCancel
            inpuTextView.isEditable = false
            placeholderLabel.text = "Fin Conversacion"
            addButton.isEnabled = false
            addButton.backgroundColor = UIColor .AppColor.Gray.greyStrong
        }
    
    }
    func setuptable(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "cellOther")
        //MessageViewUserCell
        table.register(UINib(nibName: "MessageViewUserCell", bundle: nil), forCellReuseIdentifier: "cellUser")
        table.estimatedRowHeight = 80
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var numberItems = 0
        if let count = listOfMessage?.count{
            numberItems = count
        }
        return numberItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let model = listOfMessage![indexPath.row]
        if(model.idUser == BaseManager().getUserDefault().idUser){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! MessageViewUserCell
            cell.setupCell(listOfMessage![indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOther", for: indexPath) as! MessageViewCell
            cell.setupCell(listOfMessage![indexPath.row])
            return cell
        }
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
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
      
       let requestManager = RequestMessageManager()
        let model = ModelRequestMessageHouse()
         if  inpuTextView.text.count > 0 {
            model.idRequestMessage = requestManager.giveMeId()
            model.text = inpuTextView.text
            inpuTextView.text = ""
            placeholderLabel.isHidden = !inpuTextView.text.isEmpty
            model.idUser = BaseManager().getUserDefault().idUser
            model.name = BaseManager().getUserDefault().alias
            model.date = Date()
            putTempMessage(model)
             requestManager.insertMessageFromRequest(model,request!) { (sucess) in
            
        }
        }
    }
    
    func listenFirstTime(){
          let requestManager = RequestMessageManager()
        requestManager.getRequestWithId(request!.idRequest!){(model)in
           if let new = model.listofMessage?.count {
            if(new != self.request?.listofMessage?.count){
                let factory = RequestMessageFactory()
                self.listOfMessage = factory.orderMessageAsc(model.listofMessage!)
                self.table.reloadData {
                    
                }
            }
            }
            
        }
    }
    func listenChildAdded(){
        let requestManager = RequestMessageManager()
        requestManager.listChangeOnMessages(request!){ (model) in
            /*
             // self.listOfMessage?.first(where: {$0.idRequestMessage == model.idRequestMessage})?.added = model
             // self.listOfMessage?.filter{$0.idRequestMessage == model.idRequestMessage}.first
             if let row = self.upcoming.index(where: {$0.eventID == id}) {
             array[row] = newValue
             }
             */
            if let row = self.listOfMessage?.index(where: {$0.idRequestMessage == model.idRequestMessage}){
                self.listOfMessage?[row] = model
            }else{
                if((model.idRequestMessage?.count)! > 0){
                     self.listOfMessage?.append(model)
                }
                
                
            }
           
            let factory = RequestMessageFactory()
            self.listOfMessage = factory.orderMessageAsc(self.listOfMessage!)
            self.table.reloadData {
                self.scrollToLastPosition()
            }
        }
    }
    
    func putTempMessage(_ message: ModelRequestMessageHouse){
        message.temporal = true
        listOfMessage?.append(message)
        scrollToLastPosition()
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
        func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !textView.text.isEmpty
             // placeholderLabel.isHidden =  !isEmptyString(text: textView.text)
       }
   
        func makePlaceHolderOnTextView( _ textView: UITextView){
           // textView.delegate = self
            placeholderLabel = UILabel()
            placeholderLabel.text = "Escribe texto..."
            placeholderLabel.font = UIFont.AppFont.middleFont.middlWord
            placeholderLabel.sizeToFit()
            textView.addSubview(placeholderLabel)
            placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
            placeholderLabel.isHidden =  !isEmptyString(text: textView.text)
           // placeholderLabel.textColor = UIColor.lightGray
           placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    func scrollToLastPosition(){
        table.reloadData {
            let row = self.listOfMessage!.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.table.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
        }
    }

    func isEmptyString (text : String) -> Bool{
        var result = false
        if (text.count == 0 || text == ""){
            result = true
        }
        return result
    }
}


