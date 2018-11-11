//
//  HouseDetailRequestViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class HouseDetailRequestViewController: BaseViewController ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var supView: UIView!
    @IBOutlet weak var supViewLabel: UILabel!
    @IBOutlet weak var supViewCollection: UICollectionView!
    
    @IBOutlet weak var infView: UIView!
    @IBOutlet weak var infViewLabel: UILabel!
    @IBOutlet weak var infViewCollection: UICollectionView!
    
    @IBOutlet weak var footerview: UIView!
    @IBOutlet weak var requestButton: UIButton!
    
    var controller : HouseDetailRequestController?
    var house : ModelHouse?
    var roomSelectAtIndex : IndexPath?
    
   public var modalView : ModalMain?
    
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
    
    func initView(){
        initData()
        MainHelper.circleButton(button: requestButton)
        MainHelper.borderShadowRedonde(view: requestButton)
        requestButton.backgroundColor = UIColor .AppColor.Green.greenDinosaur
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
        supViewCollection.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        infViewCollection.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
        
        MainHelper.theStyle(view: supView)
        MainHelper.theStyle(view: infView)
        MainHelper.theStyle(view: footerview)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controller!.updateCellsLayout(collectionView: supViewCollection)
        controller!.updateCellsLayout(collectionView: infViewCollection)
    }
   
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
    
    
   
    @IBAction func requestAction(_ sender: Any) {
        controller!.requestAction()
        
    }
}
