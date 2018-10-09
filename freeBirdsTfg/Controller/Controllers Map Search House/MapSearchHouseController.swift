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
    
    
    var viewMap : MapSearchHouseViewController?
     let locationManager = CLLocationManager()
    
    init(viewMap: MapSearchHouseViewController!){
        self.viewMap = viewMap
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
               /* if ((self.viewMap?.map.annotations.count)! > 0){
                    let anot = self.viewMap?.map!.annotations[0]
                    self.viewMap?.map.removeAnnotation(anot!)
                }*/
                self.viewMap?.map.setRegion(region, animated: true)
               // self.viewMap?.map.addAnnotation(annotation)
                self.viewMap?.searchMapView?.searchDirectionBar.text = annotation.title
                
            }
            else {
                annotation.title = "Unknown Place"
                self.viewMap?.map.addAnnotation(annotation)
                
            }
        })
    }
    
}



