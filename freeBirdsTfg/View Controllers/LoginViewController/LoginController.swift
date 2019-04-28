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
                        self.goProfile()
                    }else{
                
                    }
                }
                
            }else{
                Auth.auth().signIn(withEmail: userText!, password:passwd!) { (user, error) in
                    if user != nil
                    {
                        let idUser = Auth.auth().currentUser?.uid
                        FireBaseManager.getUserById(userID:idUser ?? "" ){(model) in
                            let baseManager = BaseManager()
                            baseManager.saveUserDefault(model: model);
                           // self.viewLogin!.saveUserDefault(model: model)
                    
                            if(model.houseId != nil && model.houseId != "0"){
                               self.goHome(redirection: "tiene casa")
                            }else{
                                 self.goHome(redirection: "no tiene casa")
                            }
                            
                        }
                    }else{
                        /* fire.getHouse{(success) in
                         let vc = MapSearchHouseViewController(nibName: "MapSearchHouseViewController", bundle: nil)
                         vc.listOfHouses = success
                         self.navigationController?.pushViewController(vc, animated: true)
                         }
 
 */
                     //   self.showError(error: error!)
                    }
                }
            }
            
        }else{
            //MATERIAL PONER MENSAJES DE EERROR
        }
    }
    
    func goHome(redirection:String){
        //cogemos usuario y lo metemos en default
        switch redirection {
        case "no tiene casa":
            let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
            let vc = UINavigationController(rootViewController: Objvc)
            self.viewLogin!.present(vc, animated: true) {

            }
            break;
        case "tiene casa":
            HouseManager.sharedInstance.setupData { (finish) in
                if(finish){
                    let Objvc = tabBarView()
                    self.viewLogin!.present(Objvc, animated: true) {
                    }
                }
            }
            break
        default:
            break
        }
        
    }
    
    func goProfile(){
        let Objvc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
       // let vc = UINavigationController(rootViewController: Objvc)
        self.viewLogin!.present(Objvc, animated: true) {
        }
    }
    
    
    
}
