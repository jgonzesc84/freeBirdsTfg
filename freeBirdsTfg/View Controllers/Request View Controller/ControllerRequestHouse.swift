//
//  ControllerRequestHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 25/05/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

class ControllerRequestHouse : ControllerRequestView{
    
    var view : RequestView?
    
    
    init(main:RequestView){
        
        self.view = main;
    }
}
