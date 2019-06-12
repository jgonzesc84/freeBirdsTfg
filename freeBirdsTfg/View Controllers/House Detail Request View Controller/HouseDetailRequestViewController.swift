//
//  HouseDetailRequestViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class HouseDetailRequestViewController: BaseViewController ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {

     //MARK: atributes and outlets
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var supView: UIView!
    @IBOutlet weak var supViewLabel: UILabel!
    @IBOutlet weak var supViewCollection: UICollectionView!
    
    @IBOutlet weak var infView: UIView!
    @IBOutlet weak var infViewLabel: UILabel!
    @IBOutlet weak var infViewCollection: UICollectionView!
    
    @IBOutlet weak var footerview: UIView!
   // @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var requestButton: Button!
    
    var controller : HouseDetailRequestController?
    var house : ModelHouse?
    var roomSelectAtIndex : IndexPath?
    var state : String?
   public var modalView : ModalMain?
    
    //MARK: cycle life methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = HouseDetailRequestController(requestView:self)
        prepareNav(label: titleLabel, text: "Detalle")
        MainHelper.navStyle(view:navView)
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        supViewCollection.scrollToItem(at: roomSelectAtIndex!, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
     //MARK: setup view
    
    func initView(){
        initData()
        MainHelper.circleButton(button: requestButton)
        MainHelper.borderShadowRedonde(view: requestButton)
        //requestButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
        let filteredRooms = self.house?.listOfRoom!.filter{$0.search == true}
        self.house!.listOfRoom! = filteredRooms!
        MainHelper.giveMeStyle(button: requestButton)
        if let request = house?.request{
            configureButton(request.state!)
            state = request.state!
        }else{
              configureButton("")
            state = ""
        }
    }
  
    func configureButton(_ stateRequest:(String)){
        
        let option = stateRequest
        switch (option) {
        case constant.stateAcceptRequest:
            requestButton.setTitle("  Aceptada  ", for: .normal)
            requestButton.isEnabled = false
            break
            
        case constant.statcDeclineRequest:
            requestButton.setTitle("  Cancelar  ", for: .normal)
           // requestButton.isEnabled = false
            break
            
        case constant.stateOpendRequest:
            requestButton.setTitle("  Esperando respuesta  ", for: .normal)
            requestButton.isEnabled = false
            break
            
        default:
            
            requestButton.setTitle("  Solicitar entrada  ", for: .normal)
            requestButton.isEnabled = true
          break
        }
        
    }
    func initData(){
        supViewCollection.delegate  = self
        supViewCollection.dataSource = self
        supViewCollection.register(UINib(nibName:"supViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "supCell")
        if let layout = supViewCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        infViewCollection.delegate = self
        infViewCollection.dataSource = self
        infViewCollection.register(UINib(nibName:"infViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "infCell")
        if let layout = infViewCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        supViewCollection.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        infViewCollection.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        MainHelper.theStyle(view: supView)
        MainHelper.theStyle(view: infView)
        MainHelper.theStyle(view: footerview)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controller!.updateCellsLayout(collectionView: supViewCollection)
        controller!.updateCellsLayout(collectionView: infViewCollection)
    }
    //MARK: collection view delegates
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return controller!.sizeForItemAt(collectionView: collectionView, collectionViewlayout: collectionViewLayout , indexPath: indexPath)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == supViewCollection){
            controller!.updateCellsLayout(collectionView: supViewCollection)
        }else{
             controller!.updateCellsLayout(collectionView: infViewCollection)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return controller!.numberOfItemsInSection(collectionView: collectionView)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return controller!.cellForItemAt(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

         controller!.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
    }
    
    
    //MARK: modal view methods
    
    @IBAction func requestAction(_ sender: Any) {
        switch (state) {
        case constant.statcDeclineRequest:
            let requestMng = RequestMessageManager()
            requestMng.deleteRequestFromUser(request:(self.house?.request)!, idUser: (self.house?.request?.aplicantId!)!){(sucess) in
                self.navigationController?.popViewController(animated: true)
                
            }
            break
        case constant.stateAcceptRequest:
            // ouch
            break
        default:
            controller!.requestAction()
            break;
        }
        
        
        
    }
}
