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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Busca Casa")
        MainHelper.navStyle(view:navView)
        initView()
        controller = MapSearchHouseController(viewMap:self)
        controller?.addAnnotation()
        fire.delegate = self
      //fire.updateHouseMap()
       
       
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
          setupSearchView()
          setupDetailHouseTableView()
          setupCurrentLocation()
         fire.getHouseUpdated { (succes) in
            if(succes){
                //seguir estructira poner loader y tal
            }
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
       
    }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       controller?.updateCurrentPosition(manager: manager)
       
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      return  controller?.configureAnnotation(mapView: mapView, annotation: annotation)
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
    
    func delegateGetAllHouseDelegate(model: ModelHouse){
        
    }
    
    //delegates methods
    func getHouseArray(array: Array<ModelHouse>?) {
        //do nothing see change this
    }
    
    
    
    
    /**
     configuración tableView detalle casas
     
     **/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (controller?.giveHeightForTable())! ;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
    }
    
    
}

extension MapSearchHouseViewController : getAllHouseDelegate {
    
    func isActiveSession(active: Bool) {
        
    }

    func getNewHouse(model: ModelHouse) {
     controller?.updateMap(model: model)
    }
}
