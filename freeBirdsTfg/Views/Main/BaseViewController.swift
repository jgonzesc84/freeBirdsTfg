//
//  BaseViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import FirebaseMessaging



class BaseViewController: UIViewController {

    static let IDUSER = "idUser"
    static let IDHOUSE = "idHouse"
    static let ALIAS = "alias"
    static let EMAIL = "email"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    enum LandingPages: String {
        case Register = "registro"
        case NoHouse = "No casa"
        case unFinishedRegister = "terminar Registro"
        case House = "tiene casa"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func prepareDelegate(){
    
    }
    //  MARK: - delegate roomexpandibleCell
    func callModalView() {
        
    }
    
    func animationButtons(button:UIView){
        UIView.animate(withDuration: 1) {
            button.center.y -= self.view.bounds.height/4
        }
        }
    
    func prepareNav(label : UILabel , text: String){
      
        label.text = text
        let backButton = Button(type : .custom)
        backButton.pulseColor = UIColor.AppColor.Gray.greyApp
        backButton.setImage(#imageLiteral(resourceName: "left_angle_bracket"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(goBack)))
        if (hasTopNotch) {
            
        }
        
    }
    func prepareNavRoot(label : UILabel , text: String){
        label.text = text
    }
//    func getUserDefault() -> ModelUser{ de esto se encarga el manager REFACTORY
//        let user = ModelUser()
//        user.idUser = UserDefaults.standard.object(forKey: BaseViewController.IDUSER) as? String
//        user.alias = UserDefaults.standard.object(forKey: BaseViewController.ALIAS) as? String
//         user.email = UserDefaults.standard.object(forKey: BaseViewController.EMAIL) as? String
//        if  (UserDefaults.standard.object(forKey: BaseViewController.IDHOUSE)) as? String != nil{
//            user.houseId = UserDefaults.standard.object(forKey: BaseViewController.IDHOUSE) as? String
//        }
//        return user
//    }
//    func saveUserDefault(model: ModelUser){
//        let userDefault = UserDefaults.standard
//        userDefault.set(model.idUser, forKey: BaseViewController.IDUSER)
//        userDefault.set(model.houseId, forKey:BaseViewController.IDHOUSE)
//        userDefault.set(model.alias, forKey:BaseViewController.ALIAS)
//        userDefault.set(model.email, forKey:BaseViewController.EMAIL)
//    }
    
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
    func getFCMToken() -> (String){
        let token = Messaging.messaging().fcmToken
        return token!
    }
   

}

extension BaseViewController{
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


/*
 func textFieldShouldReturn(textField: UITextField) -> Bool {
 
 //textField code
 
 textField.resignFirstResponder()  //if desired
 performAction()
 return true
 }
 
 func performAction() {
 //action events
 }
 */
