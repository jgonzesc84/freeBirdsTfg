//
//  MapSearchHouseViewController.swift
//  freeBirdsTfg
//
//  Created by Javier on 9/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapSearchHouseViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var viewsearch: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var searchMapView : searchMapView?
    var controller : MapSearchHouseController?
    var listOfHouses : Array <ModelHouse>?
   
      let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Busca Casa")
        MainHelper.navStyle(view:navView)
        initView()
        controller = MapSearchHouseController(viewMap:self)
        //let fire = FireBaseManager()
       // fire.getHouse()
        //llamar servicio para traer casa parseadas en anotaciones TAREA CONTROLADOR
    }
    
    override func viewDidAppear(_ animated: Bool) {
          setupSearchView()
          setupCurrentLocation()
    }

    func initView(){
        searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        self.searchMapView?.mapView = map
        self.map.delegate = self
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
    
    func setupCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       controller?.updateCurrentPosition(manager: manager)
       
    }
    
}
