//
//  PayGroupCollectionView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class PayGroupCollectionView: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    var modalView : ModalMain?
    
    var users : Array<ModelUser>?
    var usersSelected : Array<ModelUser>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    func commoninit(){
       
        Bundle.main.loadNibNamed("PayGroupCollectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        MainHelper.theStyle(view: mainView)
        
        users = HouseManager.sharedInstance.returnUsers()
        if let _ = usersSelected{
            
        }else{
            usersSelected = Array()
            usersSelected?.append(users![0])
        }
       
        setupCollection()
       
    }
    
    func setupCollection(){
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName:"UserPayCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cellItem")
        collection.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row > 0){
            let cell = collectionView.cellForItem(at: indexPath) as! UserPayCollectionCell
            let value = cell.touchCell()
            let index = self.usersSelected?.index(where: {$0.idUser == cell.user!.idUser})
            if (value){
                self.usersSelected?.remove(at: index!)
            }else{
                 self.usersSelected?.append(cell.user!)
            }
             //self.usersSelected?.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! UserPayCollectionCell
       //la primera celda se queda seleccionada siempre ya que es el usario que crea el gasto
        let user = users![indexPath.row]
        cell.setupCell(model: user )
        if(indexPath.row == 0){
         _ = cell.touchCell()
        }else{
            if  let _ = usersSelected?.first(where:{$0.idUser == user.idUser}){
                _ = cell.touchCell()
            }
        }
       
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
   
}
