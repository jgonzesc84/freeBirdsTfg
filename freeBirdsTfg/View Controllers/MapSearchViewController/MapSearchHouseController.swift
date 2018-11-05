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
    var userInteraction = false
    var tableViewHeight : CGFloat?
    
    var viewMap : MapSearchHouseViewController?
    let locationManager = CLLocationManager()
    var rooms = Array <ModelRoom>()
    var selectedHouse = ModelHouse()
    
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
            annotation.descriptionText = item.completeDescription
            viewMap?.map.addAnnotation(annotation)

        }
    }
    
    func userScrollMap(){
        
        if(userInteraction){
            userInteraction = false
        }else{
            
            sizeTable(show : false)
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
        annotation.descriptionText = model.completeDescription
        self.viewMap?.map.addAnnotation(annotation)
        self.viewMap?.listOfHouses?.append(model)
    }
    
    func configureAnnotation(mapView: MKMapView, annotation:FBAnnotationPoint) -> MKAnnotationView?{
        
        let annotationID = "annotationID"
        var annotationView : FBAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) {
            annotationView = dequeuedAnnotationView as? FBAnnotationView
            annotationView?.annotation = annotation
            
        }else{
            annotationView = FBAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
        }
        if let annotationView = annotationView {
            annotationView.image = UIImage(named:"houseIcon2")
            annotationView.descriptionText = annotation.descriptionText ?? "HOLA!!"
        }
        return annotationView
        
    }
    
    func didSelectAnnotation(annotation: FBAnnotationPoint ){
      
        userInteraction = true
        var MapRect =  self.viewMap?.map.visibleMapRect
        let MapPoint = MKMapPointForCoordinate(annotation.coordinate)
        
        MapRect!.origin.x = MapPoint.x - MapRect!.size.width * 0.5
        MapRect!.origin.y = MapPoint.y - MapRect!.size.height * 0.60
        
        
        self.viewMap?.map.setVisibleMapRect(MapRect!, animated: true)
        
        let id = annotation.idHouse
        var array = viewMap?.listOfHouses?.filter({ (ModelHouse) -> Bool in
            return ModelHouse.idHouse == id
        })
        selectedHouse = array![0]
        rooms = selectedHouse.listOfRoom!
        viewMap!.listOfRoom = rooms
        
        UIView.transition(with:  viewMap!.houseDetailTableView,
                          duration: 1,
                          options: .transitionCurlUp,
                          animations: {  self.viewMap!.houseDetailTableView.reloadData() })
        sizeTable(show : true)
    }
    
    func setupTableViewDetails(){
        viewMap!.houseDetailTableView.separatorStyle = UITableViewCellSeparatorStyle .none
        viewMap?.houseDetailTableView.register(UINib(nibName:"MapSearchHousedetailCell", bundle: nil), forCellReuseIdentifier: "detailCell")
    }
    
    func sizeTable(show : Bool){
      
        if(show ){
            if(!tableIsVisible){
                UIView.animate(withDuration: 1) {
                    self.viewMap!.houseDetailTableView.center.y -= (self.viewMap?.map.frame.size.height)! * 0.35
                    self.viewMap!.houseDetailTableViewConstraint.constant = (self.viewMap?.map.frame.size.height)! * 0.35
                    self.tableIsVisible = true
                }
            }
            
        }else{
            UIView.animate(withDuration: 1
                , animations: {
                    self.viewMap!.houseDetailTableView.center.y += (self.viewMap?.map.frame.size.height)! * 0.35
                    self.tableIsVisible = false
            }) { (finished: Bool) in
                self.viewMap!.houseDetailTableViewConstraint.constant = 0
            }
        }
        
    }
    
    func giveHeightForTable() -> CGFloat{
       tableViewHeight = (self.viewMap?.map.frame.size.height)! * 0.3
        return (self.viewMap?.map.frame.size.height)! * 0.35
        
    }
    
    func drawCell(tableView : UITableView , indexPath: IndexPath) -> (MapSearchHousedetailCell){
       
        let cell : MapSearchHousedetailCell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! MapSearchHousedetailCell
        cell.resetCell()
        let model = rooms[indexPath.row]
        cell.configureCell(model: model)
        return cell
    }

    func didSelectRow(tableView: UITableView, indexPath: IndexPath){
        
        let vc = HouseDetailRequestViewController (nibName:"HouseDetailRequestViewController", bundle: nil)
        viewMap?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
  
    
}



