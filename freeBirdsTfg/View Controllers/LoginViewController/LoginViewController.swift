//
//  ViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 18/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import FirebaseAuth


class LoginViewController: BaseViewController {
    

    @IBOutlet weak var labelPassw: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var passTextField: TextField!
    @IBOutlet weak var loginButton: Button!
    @IBOutlet weak var loginContainerInnerView: UIView!

    var controller : LoginController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = LoginController(viewLogin:self)
         initView()
        self.view.hideKeyboardWhenTappedAround()
        // //  [self.parentViewController.navigationController.navigationBar setHidden:TRUE];
        self.navigationController?.navigationBar.isHidden = true
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
       
        
    }
   
    func initView(){
        controller!.Style()
    }
 
    @IBAction func loginAction(_ sender: Any) {
        
        controller?.buttonAction()
    
    }
    
   
    func showError(error:Error){
       let myError = error.localizedDescription
            print(myError)
    }
    
}

