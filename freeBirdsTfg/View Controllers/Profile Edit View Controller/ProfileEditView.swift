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
    
    @IBOutlet weak var leaveHouseButton: UIButton!
    @IBOutlet weak var closeSesscionButton: UIButton!
    var controller : ProfileEditController?
    var listRoom: Array<ModelRoom>?
    var userId : String?
    var houseId :String?
    var user : ModelUser?
    var tabBar : tabBarView?
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        MainHelper.theStyle(view: mainView)
        MainHelper.circleButton(button: closeSesscionButton)
        MainHelper.circleButton(button: leaveHouseButton)
    }

    func initView(){
        controller = ProfileEditController(view:self)
        self.hideKeyboardWhenTappedAround()
        listRoom =  HouseManager.sharedInstance.house!.listOfRoom
        houseId = BaseManager().houseId()
        userId = BaseManager().userId()
        user = BaseManager().getUserDefault()
    }
  
   
    @IBAction func closeSession(_ sender: Any) {
        try! Auth.auth().signOut()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        self.viewControllers.removeAll()
//        UIApplication.shared.keyWindow?.rootViewController = homePage
        self.navigationController?.initRootViewController(vc: homePage)
        self.tabBar?.dismiss(animated: false, completion: {
            
        })
       // self.navigationController?.pushViewController(homePage, animated: true)
    }
    
    
    @IBAction func leaveHouseButton(_ sender: Any) {
        
        if let room = listRoom?.first(where: {$0.user?.idUser ?? "" == userId}){
             let manager = EditRoomUserManager()
            manager.exitUserRoom(idRoom: room.idRoom!,user: user!){
                (success) in
                if(success){
                    self.leaveTheShip()
                }else{
                   print("fallo")
                }
            }
        }else{
             leaveTheShip()
        }
       
    }
    
    func leaveTheShip(){
        HouseManager.sharedInstance.deleteUserFromHouse(idHouse: houseId!, idUser: userId!){
            (sucess) in
            if (sucess){
                UserDefaults.standard.set("0", forKey: BaseViewController.IDHOUSE)
//                let story : UIStoryboard = UIStoryboard(name:"Login", bundle: nil)
//                let alpha = story.instantiateViewController(withIdentifier: "AlphaViewController") as! AlphaViewController
//               let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
//                self.navigationController?.initRootViewController(vc: Objvc)
                let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
               
               // let vc = UINavigationController(rootViewController: Objvc)
                
//                self.present(vc, animated: true) {
//
//                }
                  self.navigationController?.initRootViewController(vc: Objvc)
                self.tabBar?.dismiss(animated: false, completion: {
                    
                })
            }else{
                print("fallo")
            }
        }
    }
    
}

