//
//  ModelHouseSection.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 13/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class ModelHouseSection: Encodable{
    
    var title : String!
    var description : String!
    var image : String?
    var imageData: UIImage?
    
    enum CodingKeys: String, CodingKey{
        case title
        case description
        case image
      
        
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(image, forKey: .image)
        
    }
    
}
