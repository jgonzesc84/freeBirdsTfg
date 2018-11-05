//
//  HouseDetailRequestViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 05/11/2018.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class HouseDetailRequestViewController: BaseViewController ,UICollectionViewDelegate ,UICollectionViewDataSource  {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = HouseDetailRequestController(requestView:self)
        prepareNav(label: titleLabel, text: "Detalle")
        MainHelper.navStyle(view:navView)
        
    }
    
    func initView(){
        
    }
  
    func initData(){
        supViewCollection.delegate  = self
        supViewCollection.dataSource = self
        supViewCollection.register(UINib(nibName:"supViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "supCell")
        infViewCollection.delegate = self
        infViewCollection.dataSource = self
        infViewCollection.register(UINib(nibName:"infViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "infCell")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return controller!.numberOfItemsInSection(collectionView: collectionView)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return UICollectionViewCell()
    }
    

   

}
