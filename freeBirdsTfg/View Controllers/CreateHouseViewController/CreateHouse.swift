//
//  CreateHouse.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 4/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class CreateHouse: BaseViewController {

   
    @IBOutlet weak var createHouseTable: CreateHouseTableViewController!
    @IBOutlet weak var labelHeder: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var buttonAccept: Button!
    
    var alreadyMoved = true
    //variables del modelo de la casa
    var house : ModelHouse?
    var price : String?
    var directionModel : ModelDirection?
    var listOfSection : Array<ModelHouseSection>?
    var listOfRoom : Array<ModelRoom>?
    var editedMode = false
    //
    
    public var modalView : ModalMain?
    public var mapView : MapViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
       
         prepareNav(label: titlelabel, text: "Crea tu Casa")
         initView()
        
    }
    func initView(){
        heardCell()
        MainHelper.acceptButtonStyle(button: buttonAccept)
        MainHelper.borderShadow(view: buttonAccept)
        MainHelper.dissableButtonCreate(button: buttonAccept)
        
        if (editedMode){
            house = ModelHouse()
            MainHelper.enabledButtonCreate(button: buttonAccept)
            buttonAccept.setTitle("Editar", for: .normal)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            HouseManager.sharedInstance.fillHouseEdited(idHouse: BaseManager().houseId(), completion: { (model, sucess) in
                if(sucess){
                    self.house = model
                    self.listOfSection = model.section
                    self.listOfRoom = model.listOfRoom
                    self.directionModel = model.direction
                    self.createHouseTable.house = model
                    self.createHouseTable.refeshPater()
                }
            
            })
        }
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (editedMode){
            self.navigationController?.navigationBar.isHidden = true
        }

    }
   
    override func viewDidAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = false
        if(alreadyMoved){
            UIView.animate(withDuration: 1) {
              //  self.buttonAccept.center.y -= self.buttonAccept.frame.height
                self.buttonAccept.alpha = 1.0
            }
            alreadyMoved = false
        }
        
    }
    /**
     @param sender es quien envia la solicitud al controlador principal
     @fucntion Metodo que escucha las acciones de las celdas, y prepara las escuchas menos en la de precio
     que recoge la info directamente
    **/
    func heardCell(){
        createHouseTable.showModalParent = { (sender) -> () in
            
            switch sender {
            case is Array<ModelHouseSection>:
                self.listOfSection = sender as? Array<ModelHouseSection>
                self.prepareButton()
                break;
            case is Array<ModelRoom>:
                self.listOfRoom = sender as? Array<ModelRoom>
                self.prepareButton()
                break;
            case is ModelDirection:
                self.directionModel = sender as? ModelDirection
                self.prepareButton()
                break;
            case is PrecioCell:
                let cell =  sender as! PrecioCell
                let price = cell.priceTextEdit.text
                self.price = price
                self.prepareButton()
                break;
            case is ModelRoom:
                let model = sender as? ModelRoom
               let index = self.listOfRoom?.firstIndex(where: {($0 === model)})
                self.listOfRoom?.remove(at: index!)
                  self.prepareButton()
                break;
            default:
                break;
            }
           
        }
        createHouseTable.showPickerParent = { (picker, true) -> () in
             self.present(picker, animated: true, completion: nil)
        }
        createHouseTable.showPickerAlertParent = { (alert, true) -> () in
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    func prepareButton(){
        if(editedMode){
            MainHelper.enabledButtonCreate(button: buttonAccept)
            buttonAccept.setTitle("Editar", for: .normal)
        }else{
            if(self.listOfRoom != nil){
                let numb = self.listOfRoom?.count
                if( numb! > 0 && self.directionModel != nil){
                    MainHelper.enabledButtonCreate(button: buttonAccept)
                }else{
                    MainHelper.dissableButtonCreate(button: buttonAccept)
                }
            }else{
                MainHelper.dissableButtonCreate(button: buttonAccept)
            }
        }
       
        
    }
    
    func prepareModal(name : String){
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        modalView?.loadContentView(name: name)
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.view.addSubview(self.modalView!)
            self.modalView?.returnCompleteHouseData = { (text) -> () in
                self.house?.description = text
                FireBaseManager.createHouse(model: self.house!){
                    (sucess)in
                    if(sucess){
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
                //redirigir a tabView
               
            }
        }
    }
    //TODO insertar id de usario en la casa
    /**
     @function Metodo que envia el modelo Casa a Firebase
    **/
    @IBAction func acceptActionButton(_ sender: Any) {
        
        editedMode ? editAction () : createAction()
        
        }
    
    
    func showIfAreSeraching(_ listHouse : Array<ModelRoom>) -> Bool{
        var result = false
        if listHouse.contains(where: {$0.search == true}){
            result = true
          // return result
        }
        return result

}
    
    func createAction(){
        self.house = ModelHouse()
        self.house!.section = listOfSection
        self.house!.listOfRoom = listOfRoom
        self.house?.direction = directionModel
        var user = Array<ModelUser>()
        user.append(BaseManager().getUserDefault())
        self.house!.user = user
        if  let list = house!.listOfRoom {
            if(showIfAreSeraching(list)){
                self.house!.searchMate = true
                prepareModal( name : "completeHouse")
            }else{
                self.house!.searchMate = false
                FireBaseManager.createHouse(model: self.house!){(sucess) in
                    if(sucess){
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                //redirigir a tab view
            }
        }else{
            print ("NANAI SIN HABITACIONES")
        }
    }
    
    func editAction(){
        
        if(listOfSection != nil){
            house!.section = listOfSection
        }
        if(listOfRoom != nil){
             house!.listOfRoom = listOfRoom
        }
        if(directionModel != nil){
            house!.direction = directionModel
        }
       
       let searching = house!.listOfRoom!.contains(where: { ($0.search!) })
       house!.searchMate = searching
       FireBaseManager.editHouse(model: house!) { (success)  in
            if(success){
              self.navigationController?.popViewController(animated: true)
            }
        }
            
        }
    }
    
    
    

    
  


