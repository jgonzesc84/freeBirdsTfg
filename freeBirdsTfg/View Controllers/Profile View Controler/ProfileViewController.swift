//
//  ProfileViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
      //MARK: atributes and outlets
    
    //navigation View
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //backGroundView
    @IBOutlet weak var backGroundView: UIView!
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
        navView.backgroundColor = UIColor .clear
        initView()
        setupTable()
        gradientStyle()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //gradientStyle()
    }
    //MARK: setup view
    
    func initView(){
        MainHelper.circleButton(button: photoButton)
        MainHelper.circleView(view : profileImage)
       // profileImage.layer.cornerRadius = 72
        profileImage.layer.borderColor = UIColor .white.cgColor
        profileImage.layer.borderWidth = 3.0
        profileImage.clipsToBounds = true
        
        continueButton.backgroundColor = UIColor .AppColor.Gray.greyApp
        continueButton.titleLabel?.font = UIFont .AppFont.titleFont.titleFont
        continueButton.tintColor = UIColor .white
        continueButton.layer.cornerRadius = 10.0
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.borderColor = UIColor .white .cgColor
        
        nameTextField.font = UIFont .AppFont.middleFont.middlWord
        nameTextField.textColor = UIColor .AppColor.Blue.blueDinosaur
        nameTextField.placeholder = "Pón tu nick"
        nameTextField.delegate = self
        
       
    }    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName:"ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        myTable.separatorStyle = UITableViewCellSeparatorStyle .none
       

    }
    
    func gradientStyle(){
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor .AppColor.Green.greenDinosaur.cgColor, UIColor .white.cgColor]
        backGroundView.layer.insertSublayer(gradient, at: 0)
    }
    //MARK: table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
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
        //creacion Usuario
       configureUser()
        let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
        let vc = UINavigationController(rootViewController: Objvc)
        self.present(vc, animated: true) {
            
        }
        
    }
    
    func configureUser(){
         let user = ModelUser()
        user.alias = nameTextField.text
        user.email = Auth.auth().currentUser?.email
        user.houseId = "0"
        FireBaseManager.createUser(model: user)
        user.idUser = Auth.auth().currentUser?.uid
        saveUserDefault(model: user);
    }
    
}

extension ProfileViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string == "" && (textField.text?.count)! <= 1){
            continueButton.isEnabled = false
            UIView.animate(withDuration: 1) {
                self.continueButton.backgroundColor = UIColor .AppColor.Gray.greyApp
                self.continueButton.setTitleColor(UIColor.white, for: .normal)
                self.continueButton.layer.borderColor = UIColor .white .cgColor
            }
        }else{
            continueButton.isEnabled = true
            UIView.animate(withDuration: 1) {
                self.continueButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
               // self.continueButton.tintColor = UIColor .AppColor.Blue.blueDinosaur
                self.continueButton.layer.borderColor = UIColor .AppColor.Green.greenDinosaur .cgColor
                
            }
        }
        
        
        return true;
    }
    
}
