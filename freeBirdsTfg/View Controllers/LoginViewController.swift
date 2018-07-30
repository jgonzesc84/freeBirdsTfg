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
    

    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var passTextField: TextField!
    @IBOutlet weak var loginButton: Button!
    
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

 
    @IBAction func loginAction(_ sender: Any) {
        
     /*   if userTextField.text != "" && passTextField.text != "" {
        
            Auth.auth().createUser(withEmail:userTextField.text!, password: passTextField.text!) { (user, error) in
                if user != nil
                {
                    print("EXITO")
                    
                }else{
                    //ERROR IMPLEMETAR ALERTA SI NO SE HA CONSEGUIDO LOGUEAER
                    if let myError = error?.localizedDescription
                    {
                        print(myError)
                    }else{
                        print("ERROR")
                    }
                }
            }
            
        }else{
            //MATERIAL PONER MENSAJES DE EERROR
        }*/
       /* let storyBoard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(newViewController, animated: true, completion: nil)*/
        // WZKTimeoutExpirationCvvAndDateViewController* vc = [[WZKTimeoutExpirationCvvAndDateViewController alloc] initWithNibName:@"WZKTimeoutExpirationCvvAndDateViewController" bundle:nil];
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

