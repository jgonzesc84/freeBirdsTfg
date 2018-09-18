//
//  MapViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 14/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import MapKit

class MapViewController: BaseViewController {

    var searchMapView : searchMapView?
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsearch: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Localizacion")
        setupSearchView()
        MainHelper.navStyle(view: navView)
        initView()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchView(){
        self.searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        self.searchMapView?.mapView = map
        let frame = CGRect(x: 0, y: 67, width: UIScreen.main.bounds.width , height: viewsearch.frame.size.height)
        self.searchMapView? .frame = frame
        self.searchMapView?.setOldFrame(frame: frame)
       // self.searchMapView?.backView .frame = CGRect(x: 0, y: 0, width: frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.searchMapView!)
       let bottomConst  = NSLayoutConstraint(item: self.searchMapView!, attribute: .top, relatedBy: .equal, toItem: navView, attribute: .bottom, multiplier: 1, constant: 0)
       // let topConstant = self.searchMapView!.topAnchor.constraint(equalTo: navView.bottomAnchor)
    //    self.view.addConstraint(topConstant)
        self.view.addConstraints([bottomConst])
      
      
    }
    func initView(){
        hearSearchBarMap()
    }
    
    func hearSearchBarMap(){
        // createHouseTable.showModalParent = { (sender) -> () in
        self.searchMapView?.getDirection = { (itemLocation) -> () in
            let locationItem = itemLocation.placemark
            self.map.addAnnotation(locationItem)
            self.setupRegion(item: itemLocation)
            
        }
    }
    func setupRegion(item : MKMapItem){
     
      
        var region =  MKCoordinateRegion();
        region.center = item.placemark.coordinate
        region =  self.map.regionThatFits(region)
        map.setRegion(region, animated: true)

}
}

/*
 if([mapView.annotations count] == 0)
 return;
 
 CLLocationCoordinate2D topLeftCoord;
 topLeftCoord.latitude = -90;
 topLeftCoord.longitude = 180;
 
 CLLocationCoordinate2D bottomRightCoord;
 bottomRightCoord.latitude = 90;
 bottomRightCoord.longitude = -180;
 
 for(MapAnnotation* annotation in mapView.annotations)
 {
 topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
 topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
 
 bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
 bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
 }
 
 MKCoordinateRegion region;
 region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
 region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
 region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
 region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
 
 region = [mapView regionThatFits:region];
 [mapView setRegion:region animated:YES];
 
 */
