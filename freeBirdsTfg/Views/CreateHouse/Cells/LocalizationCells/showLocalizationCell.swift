//
//  showLocalizationCell.swift
//  freeBirdsTfg
//
//  Created by Javier on 25/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import MapKit

class showLocalizationCell: UITableViewCell {

    @IBOutlet weak var mapBack: MKMapView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var mapCell: MKMapView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerMapView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView(){
        MainHelper.theStyle(view: mainView)
        mapCell.isUserInteractionEnabled = false
        layoutSubviews()
        self.selectionStyle = .none
        //mapBack.mapType = .satellite
        mapBack.layer.cornerRadius = mapBack.frame.size.height / 16
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        containerMapView.layer.cornerRadius = containerMapView.frame.size.height / 2
        mapCell.layer.cornerRadius = containerMapView.frame.size.height / 2
        containerMapView.borderColor = UIColor .AppColor.Green.mindApp
        containerMapView.layer.width = 2
        containerMapView.layer.shadowColor = UIColor .black .cgColor
        containerMapView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerMapView.layer.shadowRadius = 3
        containerMapView.layer.shadowOpacity = 1
        containerMapView.layer.masksToBounds = false
        containerMapView.layer.shouldRasterize = true
        containerMapView.layer.rasterizationScale = UIScreen .main.scale
    }
    
    func setupCell(annotation : MKPointAnnotation , direction : String){
        
        directionLabel.text = direction
        var region =  MKCoordinateRegion();
        region.center = annotation.coordinate
        annotation.title = direction
        region.span.longitudeDelta = 0.004
        region.span.latitudeDelta = 0.002
        self.mapCell.setRegion(region, animated: true)
        if (mapCell.annotations.count > 0){
            let anot = mapCell!.annotations[0]
            self.mapCell.removeAnnotation(anot)
        }
        self.mapCell.addAnnotation(annotation)
        //backregion
        var backRegion =  MKCoordinateRegion();
        backRegion.center = annotation.coordinate
        backRegion.span.longitudeDelta = 0.02
        backRegion.span.latitudeDelta = 0.01
        self.mapBack.setRegion(backRegion, animated: false)
      
       
    }
    func setupCell(placemark : MKPlacemark , direction : String){
        
        directionLabel.text = direction
        var region =  MKCoordinateRegion()
        region.center = placemark.coordinate
        region.span.longitudeDelta = 0.004
        region.span.latitudeDelta = 0.002
        if (mapCell.annotations.count > 0){
            let anot = mapCell!.annotations[0]
            self.mapCell.removeAnnotation(anot)
        }
        self.mapCell.setRegion(region, animated: true)
        self.mapCell.addAnnotation(placemark)
        //backregion
        var backRegion =  MKCoordinateRegion();
        backRegion.center = placemark.coordinate
        backRegion.span.longitudeDelta = 0.02
        backRegion.span.latitudeDelta = 0.01
        self.mapBack.setRegion(backRegion, animated: false)
        
    }
    
}
