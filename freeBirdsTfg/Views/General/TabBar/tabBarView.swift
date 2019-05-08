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
        //self.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.white
        let profileView = ProfileEditView()
        // profileView.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let houseView =  HouseManagerView()
        //houseView?.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let  expenseView =  ExpenseView()
        //expenseView!.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let request = RequestView()
       let viewControllerList = [expenseView,houseView,request, profileView]
       
       viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        setTabBarItems(row: 0, title: "Gastos", image: "")
        setTabBarItems(row: 1, title: "Casa", image: "")
        setTabBarItems(row: 2, title: "Chat", image: "")
        setTabBarItems(row: 3, title: "Profile", image: "")

    }
    
    func setTabBarItems(row: Int, title: String, image: String){
        let myTabBarItem1 = (self.tabBar.items?[row])! as UITabBarItem
//        myTabBarItem1.image = UIImage(named: "image")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem1.selectedImage = UIImage(named: "image")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = title
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
    }
    

   

}
