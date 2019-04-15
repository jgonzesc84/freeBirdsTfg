//
//  tabBarView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class tabBarView: UITabBarController {
    
  //  var profileView : ProfileEditView?
   // var houseView : HouseManagerView?
  //  var expenseView : ExpenseView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tabBar.tintColor = UIColor .red
        tabBar.backgroundColor = UIColor .clear
        setupBar()
       configureNav()
    }
   
    
    func configureNav(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
 
        
    }
    
    func setupBar(){
        let profileView = UINavigationController(rootViewController: ProfileEditView())
        // profileView.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let houseView = UINavigationController(rootViewController: HouseManagerView())
        //houseView?.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let  expenseView = UINavigationController(rootViewController: ExpenseView())
        //expenseView!.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        viewControllers = [profileView,houseView,expenseView]
       
        

    }

   

}
