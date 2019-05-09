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
    
    var model : ModelRequestHouse?
    var typeUser = false
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
        confugureDependState(state:model.state!)
    }
    func confugureDependState( state : String){
        
        giveMeContext()
        
        switch state {
            
        case constant.stateAcceptRequest:
         // 2 cosas esperando usuario o aceptar usuario
            if houseRequestToUser!{
                acceptButton.isEnabled = true
            }
            
//            else{
//                acceptButton.isEnabled = false
//                acceptButton.isHidden = true
//                responseLabel.isHidden = false
//                responseLabel.text = "Esperando Respuesta"
//            }
            else if(userRequestToHouse!){
                testBackgroundView.layer.borderColor = UIColor .AppColor.Green.mindApp.cgColor
                testBackgroundView.layer.borderWidth = 1.0
                acceptButton.setTitle("Ingresar en la casa", for: .normal)
                acceptButton.isEnabled = true
            }
            break

        case constant.statcDeclineRequest:
           //denegada aqui no hay mas
            acceptButton.isEnabled = false
            acceptButton.isHidden = true
            responseLabel.isHidden = false
            responseLabel.text = "Solicitiud denegada"
            break
            
        case constant.stateOpendRequest:
            if houseRequestToUser!{
                acceptButton.isEnabled = true
             
            }else{
                acceptButton.isEnabled = false
                acceptButton.isHidden = true
                responseLabel.isHidden = false
                responseLabel.text = "Esperando Respuesta"
            }
            
          //esperando usuario o aceptarla
         
            break
        default:
            
            break
        }
    }
    
    func giveMeContext(){
        let iHaveHouse = BaseManager().getUserDefault().houseId != "0"
        let isFromHouse = (model!.idHouse != nil) ? true : false
        
        houseRequestToUser = iHaveHouse || isFromHouse
        userRequestToHouse = !iHaveHouse || !isFromHouse
        
        
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
    
    }
    
    
    @IBAction func declineAction(_ sender: Any) {
        
    }
    
}
