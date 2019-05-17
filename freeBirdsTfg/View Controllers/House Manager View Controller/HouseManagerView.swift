//
//  HouseManagerView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class HouseManagerView: BaseViewController ,UICollectionViewDelegate, UICollectionViewDataSource,RefreshHouseData,cellInsertUserHouse{
  
    

    var controller : HouseManagerController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var labelRoom: UILabel!
    
    @IBOutlet weak var rootOptionView: UIView!
    @IBOutlet weak var searchUserView: UIView!
    @IBOutlet weak var searchUserButton: UIButton!
    
    @IBOutlet weak var editHouseView: UIView!
    @IBOutlet weak var editUserButton: UIButton!
    
    @IBOutlet weak var leaveHouseButton: Button!
    var roomList: Array<ModelRoom>?
    var userList: Array<ModelUser>?
    var mainUser : ModelUser?
    var roomAsigned : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupCollection()
    }
    
    

    func initView(){
        controller = HouseManagerController(view:self)
        prepareNavRoot(label:  titleLabel, text: "Edicion Casa")
        mainUser = BaseManager().getUserDefault()
        roomList = HouseManager.sharedInstance.house!.listOfRoom
        userList = HouseManager.sharedInstance.house!.user
        HouseManager.sharedInstance.delegate = self
        MainHelper.giveMeStyle(label: labelRoom)
        MainHelper.theStyle(view: searchUserView)
      //  MainHelper.theStyle(view: editHouseView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupCollection(){
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "HouseManagerRoomCollectionCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellItem")
        let numberOfItems =  roomList!.count < 2 ? 1 : 2
        calculatetItemSize(numberOfItem:CGFloat(numberOfItems))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! HouseManagerRoomCollectionCellCollectionViewCell
        let model = roomList![indexPath.row]
        if (model.user != nil){
            let owner = model.user!.idUser == mainUser?.idUser
            cell.owner = owner
        }
        cell.prepareForReuse()
        cell.resetCell()

        cell.userHaveRoom = asignedRoom()
        cell.setupCell(model, atRow: indexPath)
        if(cell.owner!){
            cell.layer.cornerRadius = 10.0
            MainHelper.borderShadow(view: cell)
        }else{
            cell.layer.cornerRadius = 0.0
            MainHelper.noBorderShadow(view: cell)
        }
        return cell
    }
    
    func calculatetItemSize( numberOfItem : CGFloat){
        //let cellScaling: CGFloat = 0.8
        let parentSize = collection.frame
        let cellWidth = parentSize.width / 2
        let cellHeight = parentSize.height
        
//        let insetX = (parentSize.width - cellWidth) / 3.0
//        let insetY  = (parentSize.height - cellHeight) / 3.0
        let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth , height: cellHeight)
        if(numberOfItem < 2){
          collection.contentInset = UIEdgeInsets(top: 0, left: parentSize.width/4, bottom: 0, right: parentSize.width/4)
        }else{
            collection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
      
        
    }
    //delegado que avisa que se ha cambiado algo en la casa
    
    func refresh() {
        roomList = HouseManager.sharedInstance.house!.listOfRoom
        userList = HouseManager.sharedInstance.house!.user
        collection.reloadData(){
            
        }
        //comparar por si ha habido cambios en rooms y en user para hacer un reload
    }
    
    func refreshCollection(succes: Bool, atRow: IndexPath) {
        roomList = HouseManager.sharedInstance.house!.listOfRoom
        userList = HouseManager.sharedInstance.house!.user
        collection.reloadItems(at: [atRow])
      
    }
    
    func asignedRoom() -> Bool{
        if  (roomList?.first(where: { $0.user?.idUser == mainUser?.idUser} )) != nil{
            roomAsigned = true
        }else{
            roomAsigned = false
        }
        return roomAsigned!
        }
    
    
    @IBAction func serachUserAction(_ sender: Any) {
        //ir a solicitudes pero poner un buscador en el top
    }
    
    @IBAction func editActionButton(_ sender: Any) {
        //ir a create House en mode edición push to  CreateHouse
        let vc = CreateHouse(nibName: "CreateHouse", bundle: nil)
        vc.editedMode = true
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @IBAction func leaveHouseButton(_ sender: Any) {
         let userId = BaseManager().userId()
        let user = HouseManager.sharedInstance.mainUser
        if let room = roomList?.first(where: {$0.user?.idUser ?? "" == userId}){
        let manager = EditRoomUserManager()
            manager.exitUserRoom(idRoom: room.idRoom!,user: user!){
                (success) in
                if(success){
                    self.leaveTheShip()
                }else{
                    print("fallo")
                }
            }
        }else{
            leaveTheShip()
        }
    }
    
    func leaveTheShip(){
        let houseId = BaseManager().houseId()
        let userId = BaseManager().userId()
        HouseManager.sharedInstance.deleteUserFromHouse(idHouse: houseId, idUser: userId){
            (sucess) in
            if (sucess){
                UserDefaults.standard.set("0", forKey: BaseViewController.IDHOUSE)
                self.navigationController?.popToRootViewController(animated: true)
                
            }else{
                print("fallo")
            }
        }
    }
}
