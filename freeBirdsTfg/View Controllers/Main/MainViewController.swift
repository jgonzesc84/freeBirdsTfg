//
//  MainViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 21/7/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Lottie
import Material
import Firebase

class MainViewController: BaseViewController {
  

    @IBOutlet weak var sepratorNavigationView: UIView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var searchHouseButton: Button!
    @IBOutlet weak var createHouseButton: Button!
    @IBOutlet weak var searchHouseView: UIView!
    @IBOutlet weak var createHouseView: UIView!
   
    @IBOutlet weak var profileButon: UIButton!
    @IBOutlet weak var requestButton: Button!
    let fire = FireBaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        lottieAnimationHouse()
        lottieAnimationSearch()
        self.animationButtons(button: self.searchHouseButton)
        self.animationButtons(button: self.createHouseButton)
        MainHelper.circleView(view: profileButon)
        MainHelper.borderShadowRedondNotRadius(view: profileButon)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.navigationBar.isHidden = true
        ImageManager.shared.checkMainUserHasImage{(model,match) in
            if(match){
                self.profileButon.setImage(model.imageData, for: .normal)
            }else{
                if let image = ImageManager.shared.mainUser.imageData{
                    self.profileButon.setImage(image, for: .normal)
                }
            }
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
     //   self.configureNav()
       
        UIView.animate(withDuration: 1) {
            self.searchHouseButton.alpha = 1
            self.createHouseButton.alpha = 1
        }
    }
    
    func initView(){
        self.configureNav()
       
        self.searchHouseButton.alpha = 0
        self.createHouseButton.alpha = 0
        self.giveSomeStyle(button: self.searchHouseButton)
        self.giveSomeStyle(button: self.createHouseButton)
        self.giveSomeStyle(button: self.requestButton)
        fire.delegate = self
    }
    func lottieAnimationHouse(){
        let animationView = LOTAnimationView(name: "construction_site")
        let frame = createHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - frame.width/2, y: frame.height/2 - frame.height/2, width: frame.size.width, height: frame.size.height )
        animationView.contentMode = .scaleToFill
        createHouseView.addSubview(animationView)
        createHouseView.sendSubviewToBack(animationView)
        animationView.play()
        animationView.loopAnimation = true
      
    }
    
    func lottieAnimationSearch(){
        let animationView = LOTAnimationView(name: "spirit_geekGray")
        let frame = searchHouseView.frame
        animationView.frame = CGRect(x:frame.width/2 - frame.width/2, y: frame.height/2 - frame.height/2, width: frame.size.width, height: frame.size.height )
        animationView.contentMode = .scaleAspectFit 
        searchHouseView.addSubview(animationView)
        searchHouseView.sendSubviewToBack(animationView )
        animationView.backgroundColor = UIColor .white
        animationView.play()
        animationView.loopAnimation = true
        
    }
 
    override func animationButtons(button:UIView){
            UIView.animate(withDuration: 1) {
                button.center.y -= self.view.bounds.height/32
       
    }

}
    func giveSomeStyle(button:Button){
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.AppColor.Gray.greyApp .cgColor
        button.layer.borderWidth = 5.0
        button.titleColor = UIColor.AppColor.Gray.greyApp
        button.pulseColor = UIColor.AppColor.Gray.greyApp
    }
    
    func configureNav(){

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        sepratorNavigationView.layer.cornerRadius = 5
        
    }
    
    @IBAction func goToSearchHouse(_ sender: Any) {
        fire.getHouse{(success) in
            var listHouses = success
            let vc = MapSearchHouseViewController(nibName: "MapSearchHouseViewController", bundle: nil)
            let requestMng = RequestMessageManager()
            let numItem = listHouses.count
            var count = 0
            if numItem > 0{
                for house in listHouses{
                    requestMng.getOneRequestTrue(house.idHouse!){
                        (req, match) in
                        if(match){
                            house.request = req
                            if let index = listHouses.firstIndex(where: {$0.idHouse == house.idHouse}){
                                listHouses[index] = house
                                count = count + 1
                            }
                            if (numItem == count){
                                vc.listOfHouses = listHouses
                                count = 0
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            count = count + 1
                            if (numItem == count){
                                vc.listOfHouses = listHouses
                                count = 0
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                       
                    }
                }
            }else{
                vc.listOfHouses = [ModelHouse]()
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
    }
    }
    @IBAction func goToCreateHouse(_ sender: Any) {
        let vc = CreateHouse(nibName: "CreateHouse", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signOutAction(_ sender: Any) {
       try! Auth.auth().signOut()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
    
        
    }
    
    @IBAction func goToRequestView(_ sender: Any) {
        //cargamos las solicitudes si tiene ponemos enabled este botón
        let requestMng = RequestMessageManager()
        requestMng.getAllRequest(BaseManager().getUserDefault().idUser!){ (model,succes) in
            if(succes){
                let vc = RequestView(nibName:"RequestView", bundle:nil)
                vc.typeUser = true
                let factory = RequestMessageFactory()
                var listOrderd = Array<ModelRequestHouse>()
                for request in model{
                    request.listofMessage = factory.orderMessageAsc(request.listofMessage!)
                    //comporbacion owner
                    listOrderd.append(request)
                }
                vc.listOfRequest = listOrderd
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                print ("no hay solicitiudes")
            }
        }
        
       
    }
    
    
    @IBAction func goToProfile(_ sender: Any) {
        let vc = ProfileViewController(nibName:"ProfileViewController", bundle:nil)
        vc.fromMain = true
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
   
}

extension  MainViewController : getAllHouseDelegate{
    
    func isActiveSession(landingPage: String) {
        
    }
    
}
