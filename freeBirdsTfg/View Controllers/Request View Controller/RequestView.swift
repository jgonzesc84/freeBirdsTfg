//
//  RequestView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class RequestView: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var listOfRequest : Array<ModelRequestHouse>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         prepareNav(label: titleLabel, text: "Solicitudes")
        // MainHelper.navStyle(view: navView)
         setuptable()       
    }

    func setuptable(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "cellItem")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberItems = 0
        if let count = listOfRequest?.count{
            numberItems = count
            }
        return numberItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! RequestCell
        cell.setupCell(listOfRequest![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messages = listOfRequest![indexPath.row].listofMessage
        let vc =  MessageView(nibName:"MessageView", bundle: nil)
        vc.listOfMessage = messages
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
 

}
