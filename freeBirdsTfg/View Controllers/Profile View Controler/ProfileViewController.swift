//
//  ProfileViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //navigation View
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //header View
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    //body View
    @IBOutlet weak var myTable: UITableView!
    
   
    
    var user : ModelUser?
    var controller : ProfileController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = ProfileController(profileView:self)
        self.prepareNav(label: titleLabel, text: "Creación Perfil")
        MainHelper.navStyle(view :  navView)
        initView()
        setupTable()
    }
    
    func initView(){
        MainHelper.circleButton(button: photoButton)
        MainHelper.circleView(view : profileImage)
       // profileImage.layer.cornerRadius = 72
        profileImage.layer.borderColor = UIColor .black.cgColor
        profileImage.layer.borderWidth = 3.0
        profileImage.clipsToBounds = true
        
    }    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName:"ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        myTable.separatorStyle = UITableViewCellSeparatorStyle .none
       

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension;
    }
   
}
