//
//  CreateHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 4/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class CreateHouse: UIViewController {

   
    @IBOutlet weak var labelHeder: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titlelabel)
         initView()
        
    }
    func initView(){
        labelHeder.font = UIFont.AppFont.middleFont.middlWord
        labelHeder.layer.borderColor = UIColor.AppColor.Green.mindApp .cgColor
        labelHeder.text = "Como es tu casa? describela!!"
        labelHeder.layer.borderWidth = 3
    }
    
    
    func prepareNav(label : UILabel){
        titlelabel .text = "Crea tu Casa"
        let backButton = Button(type : .custom)
        backButton.pulseColor = UIColor.AppColor.Gray.greyApp
        backButton.setImage(#imageLiteral(resourceName: "left_angle_bracket"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(goBack)))
        
     
    }

    func setNavBarToTheView() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Camera");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: nil);
        navItem.leftBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: true);
    }
    
    
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }

}
