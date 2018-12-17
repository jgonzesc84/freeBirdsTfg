//
//  ProfileViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
      //MARK: atributes and outlets
    
    //navigation View
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //header View
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    //body View
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var user : ModelUser?
    var controller : ProfileController?
    
    
    //MARK: cycle life methods
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = ProfileController(profileView:self)
        self.prepareNav(label: titleLabel, text: "Creación Perfil")
        MainHelper.navStyle(view :  navView)
        initView()
        setupTable()
    }
    //MARK: setup view
    
    func initView(){
        MainHelper.circleButton(button: photoButton)
        MainHelper.circleView(view : profileImage)
       // profileImage.layer.cornerRadius = 72
        profileImage.layer.borderColor = UIColor .black.cgColor
        profileImage.layer.borderWidth = 3.0
        profileImage.clipsToBounds = true
        
        continueButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
        continueButton.titleLabel?.font = UIFont .AppFont.titleFont.titleFont
        continueButton.tintColor = UIColor .AppColor.Blue.blueDinosaur
        continueButton.layer.cornerRadius = 10.0
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.borderColor = UIColor .AppColor.Green.greenDinosaur .cgColor
    }    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName:"ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        myTable.separatorStyle = UITableViewCellSeparatorStyle .none
       

    }
    //MARK: table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension;
    }
   
    
    @IBAction func continueButtonAction(_ sender: Any) {
        goHome()
    }
    func goHome(){
        let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
        let vc = UINavigationController(rootViewController: Objvc)
        self.present(vc, animated: true) {
        }
        
    }
    
}
