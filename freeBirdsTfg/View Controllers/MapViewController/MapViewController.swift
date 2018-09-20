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
    var finalPosition : CGFloat?
    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsearch: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Localizacion")
// setupSearchView()
        MainHelper.navStyle(view: navView)
        initView()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSearchView()
        MainHelper.borderShadow(view: acceptButton)
        MainHelper.acceptButtonStyle(button: acceptButton)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchView(){
       
        let widthFrame = UIScreen.main.bounds.width > viewsearch.frame.size.width ? UIScreen.main.bounds.width : self.viewsearch.frame.size.width
        
        let frame = CGRect(x: 0, y: 67, width: widthFrame , height: viewsearch.frame.size.height)
        self.searchMapView? .frame = frame
         self.searchMapView?.setOldFrame(frame: frame)
        self.view.addSubview(self.searchMapView!)
        self.viewDidLayoutSubviews()
        let bottomConst  = NSLayoutConstraint(item: self.searchMapView!, attribute: .top, relatedBy: .equal, toItem: navView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([bottomConst])
      
      
    }
    func confAcceptButton(){
        self.acceptButton.isHidden = true
        self.acceptButton.alpha = 0
        self.acceptButton.center.y += acceptButton.frame.size.height;
       
    }

    func initView(){
      //  map.mapType = .satellite
        self.searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        self.searchMapView?.mapView = map
        hearSearchBarMap()
        confAcceptButton()
        setupMap()
    }
    
    func setupMap(){
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addWaypoint(longGesture:)))
        map.addGestureRecognizer(longGesture)
        
    }
    @objc func addWaypoint(longGesture: UIGestureRecognizer) {
        
        self.map.removeAnnotations(self.map.annotations)
        let touchPoint = longGesture.location(in: map)
        let wayCoords = map.convert(touchPoint, toCoordinateFrom: map)
        let location = CLLocationCoordinate2D(latitude: wayCoords.latitude, longitude: wayCoords.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                annotation.title = self.searchMapView?.parseAddress(selectedItem: pm )
                self.map.addAnnotation(annotation)
                self.map.setCenter(annotation.coordinate, animated: true)
                self.searchMapView?.searchDirectionBar.text = annotation.title
            }
            else {
                annotation.title = "Unknown Place"
                self.map.addAnnotation(annotation)
                print("Problem with the data received from geocoder")
            }
         //   places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
        })
       
    
    }
    
    func hearSearchBarMap(){
       
        self.searchMapView?.getDirection = { (itemLocation) -> () in
            let locationItem = itemLocation.placemark
            self.map.addAnnotation(locationItem)
            self.setupRegion(item: itemLocation)
            self.acceptButton.isHidden = false
            if(self.finalPosition == nil ){
                 self.animationButtons(button: self.acceptButton)
                UIView.animate(withDuration: 1) {
                    self.acceptButton.alpha = 1
                }
            }
        }
    }
    override func animationButtons(button:UIView){
        UIView.animate(withDuration: 1) {
            button.center.y -= button.frame.size.height 
            self.finalPosition = button.center.y;
            
        }
        
    }
    
    func setupRegion(item : MKMapItem){
     
      
        var region =  MKCoordinateRegion();
        region.center = item.placemark.coordinate
         region.span.longitudeDelta = 0.004
         region.span.latitudeDelta = 0.002
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
