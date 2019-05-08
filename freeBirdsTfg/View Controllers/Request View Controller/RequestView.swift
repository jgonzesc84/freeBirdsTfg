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
    var typeUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(typeUser){
             prepareNav(label: titleLabel, text: "Solicitudes")
        }else{
             prepareNavRoot(label:  titleLabel, text: "Solicitudes")
        }
         setuptable()       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshModel()
    }
    func refreshModel(){
        if (typeUser){
            refresUserRequest()
        }else{
            refreshHouseRequest()
        }
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
        cell.typeUser = typeUser
        cell.setupCell(listOfRequest![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messages = listOfRequest![indexPath.row].listofMessage
        let vc =  MessageView(nibName:"MessageView", bundle: nil)
        vc.listOfMessage = messages
        vc.request = listOfRequest![indexPath.row]
        if(!typeUser){
            vc.hidesBottomBarWhenPushed = true;
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func refresUserRequest(){
        let requestMng = RequestMessageManager()
        requestMng.getAllRequest(BaseManager().getUserDefault().idUser!){ (model,succes) in
            if(succes){
                
                let factory = RequestMessageFactory()
                var listOrdered = Array<ModelRequestHouse>()
                for request in model{
                    request.listofMessage = factory.orderMessageAsc(request.listofMessage!)
                    listOrdered.append(request)
                }
                self.listOfRequest = listOrdered
                self.table.reloadData {
                    
                }
            }else{
                print ("error")
            }
        }
    }
    
    func refreshHouseRequest(){
        let requestMng = RequestMessageManager()
        requestMng.getAllRequestHouse(BaseManager().getUserDefault().houseId!){ (model,succes) in
            if(succes){
                
                let factory = RequestMessageFactory()
                var listOrdered = Array<ModelRequestHouse>()
                for request in model{
                    request.listofMessage = factory.orderMessageAsc(request.listofMessage!)
                    listOrdered.append(request)
                }
                self.listOfRequest = listOrdered
                self.table.reloadData {
                    
                }
            }else{
                print ("error")
            }
        }
    }
    func listenMessageArriving(){
        
    }
   
 

}
