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

class MapSearchHouseViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: atributes and outlets
   
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var viewsearch: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var houseDetailTableView: UITableView!
    @IBOutlet weak var houseDetailTableViewConstraint: NSLayoutConstraint!
    
    
    
    var searchMapView : searchMapView?
    var controller : MapSearchHouseController?
    var listOfHouses : Array <ModelHouse>?
    var listOfRoom : Array <ModelRoom>!
    let fire = FireBaseManager()
    let locationManager = CLLocationManager()
    
    //MARK: cycle life methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Busca Casa")
        MainHelper.navStyle(view:navView)
        initView()
        controller = MapSearchHouseController(viewMap:self)
        controller?.addAnnotation()
        hearSearchBarMap()
       
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
          setupSearchView()
          setupDetailHouseTableView()
          setupCurrentLocation()
         fire.getHouseUpdated { (succes,mode) in
           
            self.controller?.updateMap(model: succes ,mode:mode)
            
           
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    //MARK: setup view
    
    func initView(){
        searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        searchMapView?.mapView = map
        map.delegate = self
        houseDetailTableView.delegate = self
        houseDetailTableView.dataSource = self
        listOfRoom = Array <ModelRoom>()
        
       
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
    func setupDetailHouseTableView(){
        controller?.setupTableViewDetails()
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
    
    //MARK: update localization map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       controller?.updateCurrentPosition(manager: manager)
       
    }
    
    //MARK: map view delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let test = annotation as! FBAnnotationPoint
      return  controller?.configureAnnotation(mapView: mapView, annotation: test)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        controller?.didSelectAnnotation(annotation:(view.annotation as? FBAnnotationPoint)!)
    }

  //  - (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        controller?.userScrollMap()
    }
    
    
   /* func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        controller?.userScrollMap()
        //metodo que cunado se hay contemplado la animacion vuelva a salir las habitatciones despues de esconderse?
    }*/
    
    /**
     configuración tableView detalle casas
     
     **/
    
    //MARK: table view delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (controller?.giveHeightForTable())! ;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        controller?.didSelectRow(tableView: tableView, indexPath: indexPath)
    }
    
    //MARK: clousure searchBar  view methods
    
    func hearSearchBarMap(){
        
        self.searchMapView?.getDirection = { (itemLocation) -> () in
            
            self.controller?.setupRegion(mapRegion: itemLocation)
            
        }
    }
    
}




