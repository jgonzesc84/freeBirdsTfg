//
//  MainViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Lottie
import Material

class MainViewController: UIViewController {
  

    @IBOutlet weak var sepratorNavigationView: UIView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var searchHouseButton: Button!
    @IBOutlet weak var createHouseButton: Button!
    @IBOutlet weak var searchHouseView: UIView!
    @IBOutlet weak var createHouseView: UIView!
   
    let fire = FireBaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        lottieAnimationHouse()
        lottieAnimationSearch()
        self.animationButtons(button: self.searchHouseButton)
        self.animationButtons(button: self.createHouseButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
       
        UIView.animate(withDuration: 1) {
            self.searchHouseButton.alpha = 1
            self.createHouseButton.alpha = 1
        }
    }
    
    func initView(){
        self.configureNav()
        self.searchHouseButton.alpha = 0
        self.createHouseButton.alpha = 0
        self.giveSomeStyle(button: self.searchHouseButton)
        self.giveSomeStyle(button: self.createHouseButton)
        fire.delegate = self
    }
    func lottieAnimationHouse(){
        let animationView = LOTAnimationView(name: "construction_site")
        let frame = createHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - frame.width/2, y: frame.height/2 - frame.height/2, width: frame.size.width, height: frame.size.height )
        animationView.contentMode = .scaleToFill
        createHouseView.addSubview(animationView)
        createHouseView.sendSubview(toBack: animationView)
        animationView.play()
        animationView.loopAnimation = true
      
    }
    
    func lottieAnimationSearch(){
        let animationView = LOTAnimationView(name: "spirit_geekGray")
        let frame = searchHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - frame.width/2, y: frame.height/2 - frame.height/2, width: frame.size.width, height: frame.size.height )
       //  animationView.center = self.searchHouseView.center
        animationView.contentMode = .scaleAspectFit 
        searchHouseView.addSubview(animationView)
        searchHouseView.sendSubview(toBack:animationView )
        animationView.backgroundColor = UIColor .white
        animationView.play()
        animationView.loopAnimation = true
        
    }
 
    func animationButtons(button:UIView){
            UIView.animate(withDuration: 1) {
                button.center.y -= self.view.bounds.height/16
       
    }

}
    func giveSomeStyle(button:Button){
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.AppColor.Gray.greyApp .cgColor
        button.layer.borderWidth = 5.0
        button.titleColor = UIColor.AppColor.Gray.greyApp
        button.pulseColor = UIColor.AppColor.Gray.greyApp
    }
    
    func configureNav(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        sepratorNavigationView.layer.cornerRadius = 5
        
    }
    
    @IBAction func goToSearchHouse(_ sender: Any) {
        fire.getHouse()
    }
    @IBAction func goToCreateHouse(_ sender: Any) {
        let vc = CreateHouse(nibName: "CreateHouse", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
   
}

extension  MainViewController : getAllHouseDelegate{
    
    func isActiveSession(active: Bool) {
        
    }
    func getHouseArray(array: Array<ModelHouse>?) {
        let vc = MapSearchHouseViewController(nibName: "MapSearchHouseViewController", bundle: nil)
        vc.listOfHouses = array
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getNewHouse(model: ModelHouse) {
        //ver comop quitar est a mierda
    }
    
    
}
