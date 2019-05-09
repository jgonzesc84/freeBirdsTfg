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
    
    func refreshModel(){
        if (typeUser){
            refresUserRequest { (finish) in
                if finish{
                    self.listenMessageArriving()
                }
            }
        }else{
            refreshHouseRequest{ (finish) in
                if finish{
                    self.listenMessageArriving()
                }
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

    func listenMessageArriving(){
      
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

}
