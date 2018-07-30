//
//  MainViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Lottie

class MainViewController: UIViewController {

  
  
    @IBOutlet weak var searchHouseView: UIView!
    @IBOutlet weak var createHouseView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nav = self.navigationController
         nav?.navigationBar.isTranslucent = true
         nav?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         nav?.navigationBar.shadowImage = UIImage()
      //  let button = nav?.navigationBar.backItem
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lottieAnimationHouse()
        lottieAnimationSearch()
    }
    
    func lottieAnimationHouse(){
        let animationView = LOTAnimationView(name: "ModernPictogramsForLottie_Home-w800-h800")
        let frame = createHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - 200, y: frame.height/2 - 200, width: 400, height: 400)
        animationView.contentMode = .scaleToFill
        createHouseView.addSubview(animationView)
        createHouseView.sendSubview(toBack: animationView)
        animationView.play()
        animationView.loopAnimation = true
      
    }
    
    func lottieAnimationSearch(){
        let animationView = LOTAnimationView(name: "ModernPictogramsForLottie_MagnifyingGlass-w800-h800")
        let frame = searchHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - 200, y: frame.height/2 - 200, width: 400, height: 400)
       //  animationView.center = self.searchHouseView.center
        animationView.contentMode = .scaleAspectFit 
        searchHouseView.addSubview(animationView)
        searchHouseView.sendSubview(toBack:animationView )
        animationView.play()
        animationView.loopAnimation = true
        
    }

    

}
