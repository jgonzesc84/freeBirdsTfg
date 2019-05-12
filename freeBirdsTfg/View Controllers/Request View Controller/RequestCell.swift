//
//  RequestCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 06/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import MapKit
import CoreLocation

protocol CellRequestController{
    
    func acceptedInsert(user:Bool,idAccepted: String)
}


class RequestCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var testBackgroundView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var imageUserView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var declineButton: Button!
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var heightDeleteButton: NSLayoutConstraint!
    
    var  model : ModelRequestHouse?
    var  typeUser = false
    var  houseRequestToUser : Bool?
    var  userRequestToHouse : Bool?
    var delegate : CellRequestController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainHelper.theStyle(view: testBackgroundView)
        self.selectionStyle = .none
        MainHelper.giveMeStyle(label: descriptionLabel)
        descriptionLabel.textColor = UIColor .black
        messageView.layer.cornerRadius = 5.0
        messageView.layer.borderColor = UIColor.black.cgColor
        messageView.layer.borderWidth = 2.0
        MainHelper.borderShadow(view: testBackgroundView)
        MainHelper.giveMeStyle(button: acceptButton, 2, 5)
        MainHelper.circleView(view: mapView)
        MainHelper.circleView(view: imageUserView)
        MainHelper.giveMeStyle(label:directionLabel )
        MainHelper.giveMeStyle(label:responseLabel )
        MainHelper.cancelButton(declineButton)
        responseLabel.isHidden = true
        MainHelper.circleView(view: deleteButton)
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        
    }
    
    func  resetCell(){
    deleteButton.isHidden = true
    heightDeleteButton.constant = 0.0
    acceptButton.isEnabled = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupCell(_ model:ModelRequestHouse){
        
        self.model = model
        var title = ""
        if(typeUser){
            title = model.direction!.title!
            setupMap(model.direction!)
            imageUserView.isHidden = true
        }else{
             title = model.listofMessage!.first!.name!
             mapView.isHidden = true
        }
        let message = model.listofMessage!.last!
        directionLabel.text = title
        descriptionLabel.text = message.text
        nameLabel.text = message.name
        let stringdate = BillManager().stringFromDate(date: message.date!, format:constant.formatMeesageDate)
        dateLabel.text = stringdate
        giveMeContext()
    }
    
    func giveMeContext(){
        let iHaveHouse = BaseManager().getUserDefault().houseId != "0"
       
        if (iHaveHouse){
            let value = model?.aplicantId == BaseManager().getUserDefault().houseId
            itsRequestMine(value)
        }else{
             let value = model?.aplicantId == BaseManager().getUserDefault().idUser
            itsRequestMine(value)
        }
        
    }
    
    func itsRequestMine( _ itMine: Bool){
        
        switch(model?.state!){
            
        case constant.stateOpendRequest:
            itMine ? setupResponseLabel(show: true, text: "Esperando confirmación") :  setupAcceptButton(show: true, text: "Aceptar")
            break
        case constant.stateAcceptRequest:
            itMine ?  setupAcceptButton(show: true, text: "Añadir Usuario") :  setupResponseLabel(show: true, text: "Esperando confirmación")
            break
        case constant.statcDeclineRequest:
            setupDecline()
            break
        default:
            break
        }
    }
    func setupResponseLabel( show: Bool, text: String){
        if(show){
            acceptButton.isHidden = true
            responseLabel.isHidden = false
            responseLabel.text = text
        }else{
            responseLabel.isHidden = true
            acceptButton.isHidden = false
            
        }
    }
    func setupAcceptButton( show: Bool, text: String){
        if(show){
            acceptButton.isHidden = false
            acceptButton.setTitle(text, for: .normal)
            responseLabel.isHidden = true
        }else{
            responseLabel.isHidden = false
            acceptButton.isEnabled = false
            acceptButton.isHidden = true
        }
    }
    func setupDecline(){
        acceptButton.isEnabled = false
        acceptButton.isHidden = true
        responseLabel.isHidden = false
        responseLabel.text = "Solicitud Denegada"
        deleteButton.isHidden = false
        deleteButton.isEnabled = true
        heightDeleteButton.constant = 120.0
    }
    
    func setupMap(_ direction: ModelDirection){
        mapView.isUserInteractionEnabled = false
        var region =  MKCoordinateRegion();
        region.center = direction.coordinate!
        // annotation.title = direction.title
        region.span.longitudeDelta = 0.004
        region.span.latitudeDelta = 0.002
        mapView.setRegion(region, animated: true)
        let anno = MKPointAnnotation();
        anno.coordinate = direction.coordinate!;
        mapView.addAnnotation(anno);

    }
    @IBAction func acceptAction(_ sender: Any) {
        
        actionWithText(acceptButton.titleLabel!.text!)
       
    }
    
    @IBAction func deleteRequest(_ sender: Any) {
        
        print("you")
    }
    
    @IBAction func declineAction(_ sender: Any) {
        let requestMng = RequestMessageManager()
        requestMng.changeStateRequest(model!.idRequest!, state:constant.statcDeclineRequest){ (succes) in
            if(succes){
                let requestMng = RequestMessageManager()
                let houseId = BaseManager().getUserDefault().houseId
                 let value =  houseId != "0"
                self.resfreshViewDeleted(value, request:  self.model!, idHouse: houseId!, manager: requestMng)
            }
        }
    }
    
    func resfreshViewDeleted(_ value: Bool, request: ModelRequestHouse, idHouse: String, manager :RequestMessageManager){
        
        if (value){
            manager.deleteRequestFromHouse(request: request, idHouse: idHouse){(succes) in
             
             
            }
        }else{
            manager.deleteRequestFromUser(request:request, idUser: (self.model?.aplicantId!)!){(sucess) in
                
            }
        }
    }
    
     func actionWithText( _ text: String){
        
        if (text == "Aceptar"){
            let requestMng = RequestMessageManager()
            requestMng.changeStateRequest(model!.idRequest!, state:constant.stateAcceptRequest){ (succes) in
                if(succes){
                    
                }
            }
        }else{
            //Añadir Usuario y gestionar el ingreso del user a la casa avhvakhsvdhjacvdhjkc
            if(model?.aplicantId == BaseManager().getUserDefault().houseId){
                //el aplicant es la casa required user
                HouseManager.sharedInstance.insertUser(request: model!, userAplicant: false){ (succes) in
                    if(succes){
                        //self.delegate?.acceptedInsert( user: true,idAccepted: model?.idRequest!)
                    }
                }
            }else{
                //el aplicant es el user required la casa
                HouseManager.sharedInstance.insertUser(request: model!, userAplicant: true){ (succes) in
                    if(succes){
                        self.delegate?.acceptedInsert( user: true,idAccepted: self.model!.idRequest!)
                    }
                }
            }
        }
    }
    
}
