//
//  ProfileEditView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditView: BaseViewController {
    
    @IBOutlet weak var closeSesscionButton: UIButton!
    var controller : ProfileEditController?

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        MainHelper.theStyle(view: mainView)
        MainHelper.circleButton(button: closeSesscionButton)
    }

    func initView(){
        controller = ProfileEditController(view:self)
    }
  
 
    @IBAction func closeSession(_ sender: Any) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController = homePage
       // self.navigationController?.pushViewController(homePage, animated: true)
    }
    
}
