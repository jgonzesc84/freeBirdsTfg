//
//  ModelDirection.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import MapKit
class ModelDirection{

    var title: String?
    var coordinate: CLLocationCoordinate2D?
    init(){
        
    }
    init(title: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.coordinate = coordinate
       
    }
    enum CodingKeys: String, CodingKey{
        case title
        case latitude
        case longitude
    }
    
}

extension ModelDirection: Encodable{
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(coordinate?.latitude, forKey: .latitude)
        try container.encode(coordinate?.longitude, forKey: .longitude)
    }
    
    
}



