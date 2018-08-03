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


class LoginViewController: UIViewController {
    

    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var passTextField: TextField!
    @IBOutlet weak var loginButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //PRUEBAS MATERIAL
       initView()
        loginAllTheTime()
    }

    func initView(){
    userTextField.clearIconButton?.tintColor = UIColor .blue
    passTextField.visibilityIconButton?.tintColor = UIColor .blue
    }
    func loginAllTheTime(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil
            {
              
            }else{
           self.goHome()
            }
    }
    }
 
    @IBAction func loginAction(_ sender: Any) {
        
        if userTextField.text != "" && passTextField.text != "" {
            
            if control.selectedSegmentIndex == 0{
                Auth.auth().createUser(withEmail:userTextField.text!, password: passTextField.text!) { (user, error) in
                    if user != nil
                    {
                       self.goHome()
                        
                    }else{
                        //ERROR IMPLEMETAR ALERTA SI NO SE HA CONSEGUIDO LOGUEAER
                     self.showError(error: error!)
                    }
            }
        
            }else{
                Auth.auth().signIn(withEmail: userTextField.text!, password: passTextField.text!) { (user, error) in
                    if user != nil
                    {
                        self.goHome()
                    }else{
                      
                        self.showError(error: error!)
                    }
                }
                
                
            }
            
        }else{
            //MATERIAL PONER MENSAJES DE EERROR
        }
        
    }
    
    func goHome(){
        let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
        let vc = UINavigationController(rootViewController: Objvc)
        self.present(vc, animated: true) {
        }
    }
    func showError(error:Error){
       let myError = error.localizedDescription
            print(myError)
    }
    
}

