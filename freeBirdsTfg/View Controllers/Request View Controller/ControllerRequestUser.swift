//
//  ControllerRequestUser.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ControllerRequestUser : ControllerRequestView{
    
    var main : RequestView?
    
     init(main: RequestView) {
        
        self.main = main
    }
    
}
