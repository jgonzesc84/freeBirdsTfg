//
//  ViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 18/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var passTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PRUEBAS MATERIAL
        userTextField.clearIconButton?.tintColor = UIColor .blue
        passTextField.visibilityIconButton?.tintColor = UIColor .blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

