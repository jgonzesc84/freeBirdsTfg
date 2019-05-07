//
//  MessageView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class MessageView: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    
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
      
         prepareNav(label: titleLabel, text: "Chat")
        setuptable()
    }
    
    func setuptable(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "cellItem")
        
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
    

    

  

}
