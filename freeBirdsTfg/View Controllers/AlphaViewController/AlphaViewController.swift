//
//  AlphaViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 28/10/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import FirebaseAuth

class AlphaViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lottieAnimationLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.calculateLandingPage()
        }
       
       
    }
    
    func calculateLandingPage(){
        let fireBase = FireBaseManager()
        fireBase.delegate = self
        fireBase.isSessionActive()
    }
   /* override func viewWillAppear(_ animated: Bool) {
        lottieAnimationLoading()
    }*/
    
    func initView(){
        titleLabel.font = UIFont .AppFont.titleFont.startTitleFontSolid
        titleLabel.textColor = UIColor .AppColor.Green.mindApp
        
    }
    
    func lottieAnimationLoading(){
        let animationView = LOTAnimationView(name: "loadingAplhaAnimation")
        let frame = loadingImageView.frame
        animationView.frame = CGRect(x:frame.origin.x - 50, y: frame.origin.y - 50, width: frame.size.width, height: frame.size.height )
        animationView.contentMode = .scaleAspectFit
        loadingImageView.addSubview(animationView)
        loadingImageView.sendSubviewToBack(animationView )
        animationView.backgroundColor = UIColor .white
        animationView.play()
        animationView.loopAnimation = true
    }
  

}

extension AlphaViewController : getAllHouseDelegate {
    func getHouseArray(array: Array<ModelHouse>?) {
        
    }
    
    func getNewHouse(model: ModelHouse) {
        
    }
    
    func isActiveSession(landingPage: String) {
        switch landingPage {
        case "registro":
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(homePage, animated: true) {
                        }
              self.navigationController?.pushViewController(homePage, animated: true)
            break
        case "No casa":
            let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
                        let vc = UINavigationController(rootViewController: Objvc)
                        self.present(vc, animated: true) {
                        }
            break
        case "terminar Registro":
            let Objvc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            self.present(Objvc, animated: true) {
            }
            
            break
        case "tiene casa":
            //Setear singleton con la información de la casa usuarios TODOS, TODO gastos solo los que son del usuario.
          
            HouseManager.sharedInstance.setupData()
            let Objvc = tabBarView()
            self.navigationController?.pushViewController(Objvc, animated: true)
            self.present(Objvc, animated: true) {
            }
            break
        default:
            print("error no pasa por ningun del swicth")
            break
            
        }

        }
    
    
}
