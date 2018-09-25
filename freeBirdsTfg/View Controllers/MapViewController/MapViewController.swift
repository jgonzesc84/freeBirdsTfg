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
import CoreLocation

class MapViewController: BaseViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    

    @IBOutlet weak var acceptButton: Button!
    @IBOutlet weak var sateliteModeMapButton: Button!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsearch: UIView!
    
    let locationManager = CLLocationManager()
    var searchMapView : searchMapView?
    var pinView : MKAnnotationView!
    var finalPosition : CGFloat?
    var modeSatelite : Bool?
    
    var annotation : MKPointAnnotation?
    var placemark : MKPlacemark?
    var direction : String?
    
    public var sendLocation: ((NSMutableDictionary) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Localizacion")
       // setupSearchView()
       
        MainHelper.navStyle(view: navView)
        initView()
        setupCurrentLocation()
        MainHelper.borderShadow(view: sateliteModeMapButton)
        MainHelper.acceptButtonStyle(button: sateliteModeMapButton)
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
    
    func setupCurrentLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func initView(){
      //  map.mapType = .satellite
        self.searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        self.searchMapView?.mapView = map
        self.map.delegate = self
          modeSatelite = false
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
                annotation.title = MainHelper.parseAddress(selectedItem: pm )
                self.map.addAnnotation(annotation)
                self.map.setCenter(annotation.coordinate, animated: true)
                self.searchMapView?.searchDirectionBar.text = annotation.title
            }
            else {
                annotation.title = "Unknown Place"
                self.map.addAnnotation(annotation)
               // print("Problem with the data received from geocoder")
            }
        
        })
       
    
    }
    
    func hearSearchBarMap(){
       
        self.searchMapView?.getDirection = { (itemLocation) -> () in
             self.map.removeAnnotations(self.map.annotations)
            let locationItem = itemLocation.placemark
            self.map.addAnnotation(locationItem)
            self.setupRegion(item: itemLocation)
           
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
    // public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
       // annotation.pinImage = "pin"
       // annotation.pinColor = UIColor .AppColor.Green.mindApp
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
              //  print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                annotation.title = self.searchMapView?.parseAddress(selectedItem: pm )
                 var region =  MKCoordinateRegion();
                region.center = annotation.coordinate
                region.span.longitudeDelta = 0.004
                region.span.latitudeDelta = 0.002
                self.map.setRegion(region, animated: true)
                self.map.addAnnotation(annotation)
               // self.map.setCenter(annotation.coordinate, animated: true)*/
                self.searchMapView?.searchDirectionBar.text = annotation.title
                
            }
            else {
                annotation.title = "Unknown Place"
                self.map.addAnnotation(annotation)
              
              //  print("Problem with the data received from geocoder")
            }
            self.acceptButton.isHidden = false
            if(self.finalPosition == nil ){
                self.animationButtons(button: self.acceptButton)
                UIView.animate(withDuration: 1) {
                    self.acceptButton.alpha = 1
                }
            }
           
        })
       
    }
  

    @IBAction func changeModeViewMap(_ sender: Any) {
      
        
        UIView.transition(with: sateliteModeMapButton, duration: 0.7,
                                  options: .transitionFlipFromLeft ,
                                  animations: {
                                    if(self.modeSatelite)!{
                                        self.map.mapType = .mutedStandard
                                        self.sateliteModeMapButton.setImage(UIImage(named: "sateliteIco"), for: .normal)
                                        self.modeSatelite  = false
                                    }else{
                                        self.map.mapType = .satellite
                                        self.sateliteModeMapButton.setImage(UIImage(named: "mapIco"), for: .normal)
                                        self.modeSatelite = true
                                    }
                                   
        }, completion: nil)

    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        self.direction = searchMapView?.searchDirectionBar.text
        let dictio =  NSMutableDictionary()
        let array = map.annotations
        let obj = array[0]
        if (obj is MKPointAnnotation){
            self.annotation = (obj as? MKPointAnnotation)
             dictio["annotation"] = self.annotation
        }else{
            self.placemark = (obj as? MKPlacemark)
            dictio["annotation"] = self.placemark
        }
        dictio["location"] = self.direction
        sendLocation?(dictio)
        self.navigationController?.popViewController(animated: true)
        
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
