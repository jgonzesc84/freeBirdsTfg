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
    var  model : ModelRequestHouse?
    var  typeUser = false
    var  houseRequestToUser : Bool?
    var  userRequestToHouse : Bool?
    
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
            let value = model?.idHouse != nil
            itsRequestMine(value)
        }else{
             let value = model?.idUser != nil
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
        
        //borramos el request del user
    }
    
    @IBAction func declineAction(_ sender: Any) {
        let requestMng = RequestMessageManager()
        requestMng.changeStateRequest(model!.idRequest!, state:constant.statcDeclineRequest){ (succes) in
            if(succes){
                let requestMng = RequestMessageManager()
                let houseId = BaseManager().getUserDefault().houseId
                 let value =  houseId != "0"
                 value ? requestMng.deleteRequestFromHouse(request: self.model! ,idHouse:houseId!) : requestMng.deleteRequestFromUser(request:self.model!, idUser: (self.model?.idUser!)!)
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
        }
    }
    
}
