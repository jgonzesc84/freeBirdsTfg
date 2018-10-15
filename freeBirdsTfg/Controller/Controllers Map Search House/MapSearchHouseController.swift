//
//  MapSearchHouseController.swift
//  freeBirdsTfg
//
//  Created by Javier on 9/10/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapSearchHouseController {
    
    var description: String?
    var tableIsVisible = false
    
    var viewMap : MapSearchHouseViewController?
     let locationManager = CLLocationManager()
     var rooms = Array <ModelRoom>()
    
    init(viewMap: MapSearchHouseViewController!){
        self.viewMap = viewMap
       
    }
    
    func addAnnotation(){
        let list = viewMap?.listOfHouses
        for item in list! {
            let annotation = FBAnnotationPoint()
            annotation.idHouse = item.idHouse
            annotation.coordinate = item.direction!.coordinate!
            annotation.title = item.direction!.title
            viewMap?.map.addAnnotation(annotation)

        }
    }
    
    func updateCurrentPosition(manager: CLLocationManager){
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                annotation.title = self.viewMap?.searchMapView?.parseAddress(selectedItem: pm )
                var region =  MKCoordinateRegion();
                region.center = annotation.coordinate
                region.span.longitudeDelta = 0.004
                region.span.latitudeDelta = 0.002
                self.viewMap?.map.setRegion(region, animated: true)
                self.viewMap?.searchMapView?.searchDirectionBar.text = annotation.title
                
            }
            else {
                annotation.title = "Unknown Place"
                self.viewMap?.map.addAnnotation(annotation)
                
            }
        })
    }
    
    func updateMap(model: ModelHouse) {
    let annotation = FBAnnotationPoint()
        annotation.coordinate = model.direction!.coordinate!
        annotation.title = model.direction!.title
        annotation.idHouse = model.idHouse
        self.viewMap?.map.addAnnotation(annotation)
        self.viewMap?.listOfHouses?.append(model)
    }
    
    func didSelectAnnotation(annotation: FBAnnotationPoint ){
        //poner anotacion en posicion y rellenar celdas con las habitaciones garcias al idHouse
        /*
         MKMapRect r = [mapView visibleMapRect];
         MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
         r.origin.x = pt.x - r.size.width * 0.5;
         r.origin.y = pt.y - r.size.height * 0.25;
         [mapView setVisibleMapRect:r animated:YES];
       */
        //el esconder la tabla será cuando el usuario mueva el mapa no aqui
        sizeTable(show : false)
        let id = annotation.idHouse
        var array = viewMap?.listOfHouses?.filter({ (ModelHouse) -> Bool in
            return ModelHouse.idHouse == id
        })
        let house = array![0]
        rooms = house.listOfRoom!
        viewMap!.listOfRoom = rooms
        viewMap!.houseDetailTableView.reloadData()
        sizeTable(show : true)
    }
    
    func setupTableViewDetails(){
        viewMap!.houseDetailTableView.separatorStyle = UITableViewCellSeparatorStyle .none
         viewMap?.houseDetailTableView.register(UINib(nibName:"MapSearchHousedetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
    }
    
    func sizeTable(show : Bool){
      
        if(show && !tableIsVisible){
            UIView.animate(withDuration: 1) {
                  self.viewMap!.houseDetailTableView.center.y -= 240
                self.viewMap!.houseDetailTableViewConstraint.constant = 240
                self.tableIsVisible = true
            }
        }else{
            UIView.animate(withDuration: 1) {
                 self.viewMap!.houseDetailTableView.center.y += 240
                self.viewMap!.houseDetailTableViewConstraint.constant = 0
                self.tableIsVisible = false

            }
        }
        
    }
    
    func giveHeightForTable() -> CGFloat{
        return 240
        
    }
    
    func drawCell(tableView : UITableView , indexPath: IndexPath) -> (MapSearchHousedetailCell){
       
        let cell : MapSearchHousedetailCell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! MapSearchHousedetailCell
        cell.resetCell()
        let model = rooms[indexPath.row]
        cell.configureCell(model: model)
        return cell
    }

    
    
  
    
}



