//
//  ProfileViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    
    var controller : ProfileController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = ProfileController(profileView:self)
        self.prepareNav(label: titleLabel, text: "Creación Perfil")
        MainHelper.navStyle(view :  navView)
        
    }
    
    func initView(){
        
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
        
        return   UITableViewCell()
    }
    

   
}
