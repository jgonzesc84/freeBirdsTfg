//
//  ProfileViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBOutlet weak var closeSessionButton: UIButton!
    
    var user : ModelUser?
    var controller : ProfileController?
    var register = false
    var fromMain = false
    var imagePicker = UIImagePickerController()
    
    
    
    
    //MARK: cycle life methods
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = ProfileController(profileView:self)
        self.prepareNav(label: titleLabel, text: "Creación Perfil")
        MainHelper.navStyle(view :  navView)
        navView.backgroundColor = UIColor .clear
        initView()
        self.view.hideKeyboardWhenTappedAround()
       // setupTable()
       // gradientStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageManager().refreshMainUser()
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
       
        closeSessionButton.setTitle("Cerrar Session", for: .normal)
        giveStyleProfile(closeSessionButton)
        closeSessionButton.backgroundColor = UIColor.AppColor.Green.mindApp
        
        nameTextField.font = UIFont .AppFont.middleFont.middlWord
        nameTextField.textColor = UIColor .AppColor.Gray.greyStrong
        nameTextField.placeholder = "Pón tu nick"
        nameTextField.delegate = self
        
        if(register){
             self.prepareNav(label: titleLabel, text: "Creación Perfil")
            closeSessionButton.isHidden = true
            closeSessionButton.isEnabled = false
            continueButton.setTitle("Continuar", for: .normal)
            giveStyleProfile(continueButton)
        }else if(fromMain){
            self.navigationController?.navigationBar.isHidden = false
             self.prepareNav(label: titleLabel, text: "Editar")
            continueButton.setTitle("Editar", for: .normal)
            giveStyleProfile(continueButton)
            continueButton.backgroundColor = UIColor .AppColor.Green.mindApp
            closeSessionButton.isHidden = false
            closeSessionButton.isEnabled = true
            nameTextField.text = HouseManager.sharedInstance.mainUser!.alias
            ImageManager.shared.checkMainUserHasImage{(model,match) in
                if(match){
                    self.profileImage.image = model.imageData
                }else{
                    if let image = HouseManager.sharedInstance.mainUser!.imageData{
                        self.profileImage.image = image
                    }
                }
            }
        }else{
            self.prepareNav(label: titleLabel, text: "Editar")
            continueButton.setTitle("Editar", for: .normal)
            giveStyleProfile(continueButton)
            continueButton.backgroundColor = UIColor .AppColor.Green.mindApp
            closeSessionButton.isHidden = false
            closeSessionButton.isEnabled = true
            nameTextField.text = HouseManager.sharedInstance.mainUser!.alias ?? ""
//            ImageManager.shared.checkMainUserHasImage{(model,match) in
//                if(match){
//                    self.profileImage.image = model.imageData
//                }else{
//                    if let image = HouseManager.sharedInstance.mainUser!.imageData{
//                        self.profileImage.image = image
//                    }
//                }
//            }
            ImageManager.shared.checkUserImage(HouseManager.sharedInstance.mainUser!){(model, match) in
                if (match){
                    self.profileImage.image = model.imageData
                }else{
                    
                }
            }

        }
        imagePicker.delegate = self
    }    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName:"ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        myTable.separatorStyle = UITableViewCell.SeparatorStyle .none
       

    }
    
    func giveStyleProfile( _ button:UIButton){
        button.backgroundColor = UIColor .AppColor.Gray.greyApp
        button.titleLabel?.font = UIFont .AppFont.titleFont.titleFont
        button.tintColor = UIColor .white
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor .white .cgColor
    }
    
    func gradientStyle(){
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [UIColor .AppColor.Green.mindApp.cgColor, UIColor .white.cgColor]
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
        
        return UITableView.automaticDimension;
    }
   
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if (register){
             goHome()
        }else
        if(fromMain){
           actualizeUser()
            self.dismiss(animated: true, completion: nil)
        }else{
            actualizeUser()
        }
        
       
    }
    func goHome(){
        //creacion Usuario
       configureUser()
        let Objvc = MainViewController(nibName: "MainViewController", bundle: nil)
        self.navigationController?.pushViewController(Objvc, animated: true)
        
    }
    func actualizeUser(){
       let aliasUser = nameTextField.text
        let model = HouseManager.sharedInstance.mainUser!
        model.alias = aliasUser
        if let imageData = profileImage.image{
            model.imageData = imageData
           HouseManager.sharedInstance.mainUser?.imageData = imageData
        }
        FireBaseManager.editeUser(model: model)
        nameTextField.resignFirstResponder()
    }
    
    func configureUser(){
         let user = ModelUser()
        user.alias = nameTextField.text
        user.email = Auth.auth().currentUser?.email
        user.houseId = "0"
        user.imageData = profileImage.image;
        FireBaseManager.createUser(model: user)
        user.idUser = Auth.auth().currentUser?.uid
        let baseManager = BaseManager()
        baseManager.saveUserDefault(model: user);
    }
    
    
    @IBAction func closeSessionAction(_ sender: Any) {
        
        FireBaseManager.sharedInstance.ref.removeAllObservers()
        ImageManager.shared.resetAll()
        try! Auth.auth().signOut()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func takeImageAction(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
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
                self.continueButton.backgroundColor = UIColor .AppColor.Green.mindApp
               //self.continueButton.tintColor = UIColor .AppColor.Blue.blueDinosaur
                self.continueButton.layer.borderColor = UIColor .AppColor.Green.mindApp .cgColor
                
            }
        }
        
        
        return true;
    }
    
}
