//
//  HouseManagerView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class HouseManagerView: BaseViewController {
    
    var controller : HouseManagerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView(){
        controller = HouseManagerController(view:self)
    }
   

}
