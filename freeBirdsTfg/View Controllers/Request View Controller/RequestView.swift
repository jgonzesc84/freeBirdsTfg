//
//  RequestView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class RequestView: BaseViewController, UITableViewDelegate, UITableViewDataSource , CellRequestController{
   

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var listOfRequest : [ModelRequestHouse]?
    var typeUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if(typeUser){
             prepareNav(label: titleLabel, text: "Solicitudes")
        }else{
             prepareNavRoot(label:  titleLabel, text: "Solicitudes")
        }
        
         setuptable()
         listAddedRequest()
         listDeleteRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(BaseManager().houseId() != "0"){
              self.navigationController?.navigationBar.isHidden = true
        }else{
            self.navigationController?.navigationBar.isHidden = false
        }
     
    }
  
    override func viewWillAppear(_ animated: Bool) {
         refreshModel()
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
        cell.resetCell()
        cell.typeUser = typeUser
        cell.setupCell(listOfRequest![indexPath.row])
        cell.delegate = self
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
    ///escuchar las ediciones!!!
    func refreshModel(){
        if (typeUser){
            refresUserRequest { (finish) in
                if finish{
                    self.listenMessageArriving()
                }
            }
        }else{
            refreshHouseRequest{ (finish) in
                 self.listenMessageArriving()
            }
        }
    }
    
    func refresUserRequest(completion:@escaping(Bool)-> Void){
        let requestMng = RequestMessageManager()
        requestMng.getAllRequest(BaseManager().getUserDefault().idUser!){ (model,succes) in
           self.reloadWithDatService(model, succes: succes)
            completion(true)
        }
    }
    
    func refreshHouseRequest(completion:@escaping(Bool)-> Void){
        let requestMng = RequestMessageManager()
        requestMng.getAllRequestHouse(BaseManager().getUserDefault().houseId!){ (model,succes) in
           self.reloadWithDatService(model, succes: succes)
             completion(true)
        }
    }
    ///escucahr los insert
    func listAddedRequest(){
        typeUser ? requestAddedUser(BaseManager().userId()) : requestAddedHouse(BaseManager().houseId())
    }
    
    func requestAddedHouse( _ idHouse: String){
        let requestMsg = RequestMessageManager()
        requestMsg.requestAddedHouse(idHouse: idHouse) { (request) in
            if(self.listOfRequest == nil){
                self.listOfRequest = Array<ModelRequestHouse>()
            }
            self.listOfRequest?.append(request)
            self.table.reloadData {
                
            }
        }
    }
    func requestAddedUser( _ idUser: String){
        let requestMsg = RequestMessageManager()
        requestMsg.requestAddedUser(idUser: idUser) { (request) in
            if(self.listOfRequest == nil){
                self.listOfRequest = Array<ModelRequestHouse>()
            }
            self.listOfRequest?.append(request)
            self.table.reloadData {
                
            }
        }
    }
   
    func listDeleteRequest(){
        typeUser ? requestDeletedUser(BaseManager().userId()) : requestDeletedHouse(BaseManager().houseId())
    }
    //deletes
    func requestDeletedHouse( _ idHouse: String){
        let requestMsg = RequestMessageManager()
        requestMsg.requestIsDeletedHouse(idHouse: idHouse) { (idRequest) in
            if let row = self.listOfRequest?.index(where: {$0.idRequest == idRequest}){
                self.listOfRequest?.remove(at:row )
                self.table.reloadData {
                    
                }
            }
        }
        
    }

    func requestDeletedUser( _ idUser: String){
        let requestMsg = RequestMessageManager()
        requestMsg.requestIsDeletedUser(idUser: idUser) { (idRequest) in
            if let row = self.listOfRequest?.index(where: {$0.idRequest == idRequest}){
                self.listOfRequest?.remove(at:row )
                self.table.reloadData {
                    
                }
            }
        }
        
    }


    func listenMessageArriving(){
        if (self.listOfRequest == nil){
            self.listOfRequest = Array<ModelRequestHouse>()
        }
        for request in self.listOfRequest!{
            let requestMng = RequestMessageManager()
            requestMng.getRequestEdited(request.idRequest!) { (model) in
                if let row = self.listOfRequest?.index(where: {$0.idRequest == model.idRequest}){
                    let factory = RequestMessageFactory()
                    model.listofMessage = factory.orderMessageAsc(model.listofMessage!)
                    self.listOfRequest?[row] = model
                    self.table.reloadData {
                        
                    }
                }
            }
        }
    }
    
    func reloadWithDatService(_ listOfrequest: Array<ModelRequestHouse>, succes: Bool){
        if(succes){
            let factory = RequestMessageFactory()
            var listOrdered = Array<ModelRequestHouse>()
            for request in listOfrequest{
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
    
    func acceptedInsert(user: Bool,idAccepted:String) {
        if (user){
            let manager = RequestMessageManager()
            manager.setCancellAllRequestUser(listOfRequest: listOfRequest!, idAccepted: idAccepted)
            let story : UIStoryboard = UIStoryboard(name:"Login", bundle: nil)
            let alpha = story.instantiateViewController(withIdentifier: "AlphaViewController") as! AlphaViewController
            self.navigationController?.popToRootViewController(animated: true)
          
           
    }
    }

}
