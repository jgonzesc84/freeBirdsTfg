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
    //
    
    public var modalView : ModalMain?
    public var mapView : MapViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titlelabel, text: "Crea tu Casa")
         initView()
        
    }
    func initView(){
        labelHeder.font = UIFont.AppFont.middleFont.middlWord
        labelHeder.layer.borderColor = UIColor.AppColor.Green.mindApp .cgColor
        labelHeder.text = "Como es tu casa? describela!!"
        labelHeder.layer.borderWidth = 3
        heardCell()
        MainHelper.acceptButtonStyle(button: buttonAccept)
        MainHelper.borderShadow(view: buttonAccept)
        MainHelper.dissableButtonCreate(button: buttonAccept)
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
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
            case is Array<ModelRoom>:
                self.listOfRoom = sender as? Array<ModelRoom>
                self.prepareButton()
                break;
            case is Array<ModelHouseSection>:
                self.listOfSection = sender as? Array<ModelHouseSection>
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
            default:
                break;
            }
           
        }
    }
   
    func prepareButton(){
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
    
    func prepareModal(name : String){
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        modalView?.loadContentView(name: name)
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.view.addSubview(self.modalView!)
            self.modalView?.returnCompleteHouseData = { (text) -> () in
                self.house = ModelHouse(price: self.price, section: self.listOfSection, listOfRoom: self.listOfRoom!, direction: self.directionModel!, completeDescription: text )
                FireBaseManager.createHouse(model: self.house!)
            }
        }
    }
    //TODO insertar id de usario en la casa
    /**
     @function Metodo que envia el modelo Casa a Firebase
    **/
    @IBAction func acceptActionButton(_ sender: Any) {
        //aqui llamar a la vista modal de completion house
        prepareModal( name : "completeHouse")
        
        
        /*house = ModelHouse(price: price, section: listOfSection, listOfRoom: listOfRoom!, direction: directionModel!)
        FireBaseManager.createHouse(model: house!)*/
        
        
    }


}
