//
//  ProfileEditView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ProfileEditView: BaseViewController {
    
    var controller : ProfileEditController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView(){
        controller = ProfileEditController(view:self)
    }
  
 

}
