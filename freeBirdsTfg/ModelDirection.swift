//
//  ModelDirection.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import MapKit
class ModelDirection {

    var title: String?
    var coordinate: CLLocationCoordinate2D?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.coordinate = coordinate
       
    }
    
}
