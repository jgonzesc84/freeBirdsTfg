//
//  LoginController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/10/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginController{
    
    var viewLogin : LoginViewController?
    
    init(viewLogin : LoginViewController?){
        self.viewLogin = viewLogin
    }
    
    func Style(){
        MainHelper.giveMeStyle(label: self.viewLogin!.labelLogin)
        self.viewLogin!.labelLogin.font = UIFont.AppFont.titleFont.navTitleFont
        self.viewLogin!.labelLogin.textColor = UIColor.AppColor.Blue.blueDinosaur
        
        MainHelper.theStyle(view: self.viewLogin!.loginContainerInnerView)
        MainHelper.borderShadow(view:  self.viewLogin!.loginContainerInnerView)
        
        self.viewLogin!.labelUser.textColor = UIColor.AppColor.Blue.blueDinosaur
        self.viewLogin!.labelPassw.textColor = UIColor.AppColor.Blue.blueDinosaur
        
        self.viewLogin!.loginContainerInnerView.layer.cornerRadius =  self.viewLogin!.loginContainerInnerView.frame.size.width / 32
        self.viewLogin!.loginContainerInnerView.layer.borderColor = UIColor .AppColor.Blue.blueDinosaur .cgColor
        self.viewLogin!.loginContainerInnerView.layer.borderWidth = 1
       
        
        self.viewLogin!.userTextField.textColor = UIColor .AppColor.Green.greenDinosaur
        self.viewLogin!.passTextField.textColor = UIColor .AppColor.Green.greenDinosaur
       
        self.viewLogin!.userTextField.font = UIFont .AppFont.middleFont.middlWord
        self.viewLogin!.passTextField.font = UIFont .AppFont.middleFont.middlWord
        
        self.viewLogin!.userTextField.placeholderActiveColor = UIColor .AppColor.Green.greenDinosaur
        self.viewLogin!.passTextField.placeholderActiveColor = UIColor .AppColor.Green.greenDinosaur
        
        self.viewLogin!.userTextField.dividerActiveColor = UIColor .AppColor.Green.greenDinosaur
        self.viewLogin!.passTextField.dividerActiveColor = UIColor .AppColor.Green.greenDinosaur
        
        self.viewLogin!.userTextField.clearIconButton?.tintColor = UIColor .AppColor.Green.greenDinosaur
        self.viewLogin!.passTextField.visibilityIconButton?.tintColor = UIColor .AppColor.Green.greenDinosaur
        
        self.viewLogin!.loginButton.layer.cornerRadius = self.viewLogin!.loginButton.frame.size.height / 2
        
        self.viewLogin!.loginButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
        self.viewLogin!.loginButton.layer.borderWidth = 0.0
        
      
    }
        
    
    func buttonAction(){
        let userText = self.viewLogin!.userTextField.text
        let passwd = self.viewLogin!.passTextField.text
        if  userText != "" && passwd != "" {
            if  self.viewLogin!.control.selectedSegmentIndex == 1{
                Auth.auth().createUser(withEmail:userText! , password: passwd!) { (user, error) in
                    if user != nil
                    {
                        //cambiar ir a pantalla de Profile para completar la creación de usuario
                       // self.goHome()
                        self.goProfile()
                    }else{
                        //ERROR IMPLEMETAR ALERTA SI NO SE HA CONSEGUIDO LOGUEAER
                      //  self.showError(error: error!)
                    }
                }
                
            }else{
                Auth.auth().signIn(withEmail: userText!, password:passwd!) { (user, error) in
                    if user != nil
                    {
                    self.goHome()
                    }else{
                        
                     //   self.showError(error: error!)
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
        self.viewLogin!.present(vc, animated: true) {
        }
    }
    
    func goProfile(){
        let Objvc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
       // let vc = UINavigationController(rootViewController: Objvc)
        self.viewLogin!.present(Objvc, animated: true) {
        }
    }
    
    
    
}
