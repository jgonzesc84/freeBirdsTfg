//
//  PageView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class PageView: UIPageViewController ,UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    lazy var subViewcontroller:[UIViewController] = {
        return[
        UINavigationController(rootViewController: ProfileEditView()),
        UINavigationController(rootViewController: HouseManagerView()),
        UINavigationController(rootViewController: ExpenseView())
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitView()
        configureNav()
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func InitView(){
        self.delegate = self;
        self.dataSource = self;
        setViewControllers([subViewcontroller[0]], direction: .forward , animated: true) { (Bool) in
            
        }
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
    
   
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewcontroller.index(of:viewController)  ?? 0
        if (currentIndex <= 0){
            return nil
        }
        return subViewcontroller[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewcontroller.index(of:viewController)  ?? 0
        if (currentIndex >= (subViewcontroller.count) - 1){
            return nil
        }
        return subViewcontroller[currentIndex+1]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
       return subViewcontroller.count
    }
}
