//
//  CreateHouseTableViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 5/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//  

import UIKit
import MapKit

class CreateHouseTableViewController: UIView , UITableViewDelegate, UITableViewDataSource, PriceDelegate {
 
    @IBOutlet weak var createTable: UITableView!
    @IBOutlet var contentView: UIView!
    var annotationLocation : MKPointAnnotation?
    var placemarkLocation : MKPlacemark?
    var direction : String?
    var directionModel : ModelDirection?
    var price = ""
    let titleSection = ["Habitaciones","Secciones","Localización"]
    var editAddRoomRow = 0
    var editSectionRow = 0
    
    public var cellCollection : HouseSectionCell?
    public var sendLocationToParent: ((Any) -> ())?
    public var showModalParent: ((Any) -> ())?
    
    public var showPickerParent: ((UIImagePickerController,Bool) -> ())?
     public var showPickerAlertParent: ((UIAlertController,Bool) -> ())?
    
    public var listOfRoom = Array<ModelRoom>()
    public var modalView : ModalMain?
    public var house: ModelHouse?
    
 //  MARK: - cicle life
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("CreateHouseTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        createTable.delegate = self
        createTable.dataSource = self
        initView()
    }

    func initView(){
        
        //createTable.register(UINib(nibName:"PrecioCell", bundle: nil), forCellReuseIdentifier: "PrecioCell")
        createTable.register(UINib(nibName:"roomCell", bundle: nil), forCellReuseIdentifier: "roomCell")
        createTable.register(UINib(nibName:"HouseSectionCell", bundle: nil), forCellReuseIdentifier: "HouseSectionCell")
        createTable.register(UINib(nibName:"LocalizationCell",bundle: nil), forCellReuseIdentifier: "LocalizationCell")
        createTable.register(UINib(nibName:"createHouseTableSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerSection")
        createTable.register(UINib(nibName:"showLocalizationCell", bundle: nil), forCellReuseIdentifier: "showlocalizationCell")
        createTable.separatorStyle = UITableViewCell.SeparatorStyle .none
       
    }
    
  //  MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
       
        return titleSection.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //poner las listas para saber cuantas filas hay en la seccion
       
        switch section {
        case 0 :
          return listOfRoom.count+1
        case 1 :
            return 1
        case 2:
            return 1
        default:
            return 1
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let title = titleSection[indexPath.section]
        switch title {
//        case "Precio":
//            return 80
        case "Habitaciones":
           return 75
        case "Secciones":
            return 300
        case "Localización":
            if((self.annotationLocation) != nil || (self.placemarkLocation) != nil){
               return 187
            }else{
              return 75
            }
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let numbSection = indexPath.section
        switch numbSection {
//        case 0:
//            let cell : PrecioCell = tableView.dequeueReusableCell(withIdentifier: "PrecioCell", for: indexPath) as! PrecioCell
//            cell.delegate = self
//            cell.sendInfo = { (priceCell) -> () in
//                 self.showModalParent?(priceCell)
//            }
//            return cell
        
        case 0:
            
            let cell : roomCell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! roomCell
            cell.prepareForReuse()
            cell.showModal = { (cellExpandible) -> () in
                self.prepareModal(name : "createRoom" )
               
                if let topVC = UIApplication.getTopMostViewController() {
                    topVC.view.addSubview(self.modalView!)
                }
            }
            if(indexPath.row>0){
                 cell.setup(room: listOfRoom[indexPath.row-1])
            }
        
            return cell
        case 1:
            
            cellCollection = tableView.dequeueReusableCell(withIdentifier: "HouseSectionCell", for: indexPath) as? HouseSectionCell
            cellCollection?.showModalToParent = { (sender) -> () in
                switch  sender{
                case is Int:
                    let position = sender as! Int
                    self.editSectionRow = position
                    self.prepareModal(name : "editSection" )
                    self.modalView?.fillModal(model: self.cellCollection?.listOfModelHouseSection[position] as Any )
                    if let topVC = UIApplication.getTopMostViewController() {
                        topVC.view.addSubview(self.modalView!)
                    }
                    break;
                case is SectionHouseCollectionViewCell:
                    self.prepareModal(name :"createSection" )
                    if let topVC = UIApplication.getTopMostViewController() {
                        topVC.view.addSubview(self.modalView!)
                    }
                    break;
                case is Array<ModelHouseSection>:
                    let listSection = sender as! Array<ModelHouseSection>
                    self.showModalParent?(listSection as Any)
                break;
                default :
                    break;
                }
                
            }
            return cellCollection!
        case 2:
            if((self.annotationLocation) != nil || (self.placemarkLocation) != nil){
                let cell : showLocalizationCell = tableView.dequeueReusableCell(withIdentifier: "showlocalizationCell", for: indexPath) as! showLocalizationCell
                if(self.annotationLocation != nil){
                    cell.setupCell(annotation: self.annotationLocation! , direction: self.direction!)
                }else{
                    cell.setupCell(placemark: self.placemarkLocation! , direction: self.direction!)
                }
                return cell
            }else{
                let cell : LocalizationCell = tableView.dequeueReusableCell(withIdentifier: "LocalizationCell", for: indexPath) as! LocalizationCell
                cell.goToMapView = { (cell) -> () in
                    let vc = MapViewController (nibName: "MapViewController", bundle: nil)
                    vc.sendLocation = { (dictio) -> () in
                        let obj = dictio["annotation"]
                        if (obj is MKPointAnnotation){
                            self.annotationLocation = obj as! MKPointAnnotation?
                            self.directionModel = ModelDirection(title:(self.annotationLocation?.title)!, coordinate: (self.annotationLocation?.coordinate)!)
                        }else{
                            self.placemarkLocation = obj as! MKPlacemark?
                            self.directionModel = ModelDirection(title:(self.placemarkLocation?.title)!, coordinate: (self.placemarkLocation?.coordinate)!)
                        }
                        self.direction = dictio["direction"] as! String?
                        self.createTable.reloadData()
                        self.showModalParent?(self.directionModel!)
                    }
                    if let topVC = UIApplication.getTopMostViewController() {
                        topVC.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = titleSection[indexPath.section]
        
        switch sectionTitle {
        case "Habitaciones":
            var row = indexPath.row
            if(row > 0){
                row -= 1
                editAddRoomRow = row
                prepareModal(name : "editRoom" )
                modalView?.fillModal(model: listOfRoom[row])
                if let topVC = UIApplication.getTopMostViewController() {
                    topVC.view.addSubview(self.modalView!)
                }
            }
            
            break;
        case "Localización":
            let cell = tableView.cellForRow(at:indexPath)
            if(cell is showLocalizationCell){
                let cellWithDirection = cell as! showLocalizationCell
                let vc = MapViewController (nibName: "MapViewController", bundle: nil)
                let listOfAnnotation = cellWithDirection.mapCell.annotations
                let annotation = listOfAnnotation[0]
                switch annotation{
                case is MKPointAnnotation:
                vc.annotation =  annotation as? MKPointAnnotation
                break
                case is MKPlacemark:
                 vc.placemark = annotation as? MKPlacemark
                break
                default:
                break
                }
                vc.sendLocation = { (dictio) -> () in
                    let obj = dictio["annotation"]
                    if (obj is MKPointAnnotation){
                        self.annotationLocation = obj as! MKPointAnnotation?
                        self.directionModel = ModelDirection(title:(self.annotationLocation?.title)!, coordinate: (self.annotationLocation?.coordinate)!)
                    }else{
                        self.placemarkLocation = obj as! MKPlacemark?
                        self.directionModel = ModelDirection(title:(self.placemarkLocation?.title)!, coordinate: (self.placemarkLocation?.coordinate)!)
                    }
                    self.direction = dictio["direction"] as! String?
                    self.createTable.reloadData()
                    self.showModalParent?(self.directionModel!)
                }
                if let topVC = UIApplication.getTopMostViewController() {
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        break;
        default:
            
            break
        }
    }
    
    //  MARK: - Table view Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = titleSection[section]
        let cell = self.createTable.dequeueReusableHeaderFooterView(withIdentifier: "headerSection")
        let header = cell as! createHouseTableSection
        header.titleLabel.text = title
        return cell
    }
    //solo se puede borrar las celdas de la seccion Añadir habitacion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0 && indexPath.row > 0){
            return true
        }
       return false
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                        title: "Flag") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                            let row = indexPath.row-1
                                            let model = self.listOfRoom[row]
                                            if let userId = model.user?.idUser, model.user?.idUser != nil{
                                                if(userId.count > 0){
                                                    if let topVC = UIApplication.getTopMostViewController() {
                                                        topVC.view.addSubview(self.showError(text:"No se puede eliminar una habitacion con un usuario dentro"))
                                                        completionHandler(true)
                                                    }
                                                }else{
                                                    self.listOfRoom.remove(at: row)
                                                    tableView.deleteRows(at: [indexPath], with: .automatic)
                                                    completionHandler(true)
                                                    self.showModalParent?(model)
                                                }
                                            }else{
                                                self.listOfRoom.remove(at: row)
                                                tableView.deleteRows(at: [indexPath], with: .automatic)
                                                completionHandler(true)
                                                self.showModalParent?(model)
                                            }
                                          
        }
        deleteAction.image = UIImage(named: "trash_ico")
        deleteAction.backgroundColor = UIColor .AppColor.Green.mindApp
         let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    func haveUser( _ model: ModelRoom){
    
    }
    //  MARK: - delegate cell Price
   
    func passPrice(priceString: String?) {
        price = priceString!
    }
    /**
     @function Metododo que le da tamaño a la vista modal y deja un bloque escuchando la respuesta de este
     **/
    func prepareModal(name: String){
        self.modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        self.modalView?.loadContentView(name: name)
        self.heardModalView()
    }
    /**
    @funcion Metodo que escucha el clousure de las vista modales y avisa a CreateHouse Vista contedora
    **/
    func heardModalView(){
        
        self.modalView?.returnData = { (model) -> () in
            
            if model is ModelRoom{
                let test = model as! ModelRoom
                self.listOfRoom.append(test)
                self.createTable.reloadData()
                self.showModalParent?(self.listOfRoom)
            }else if model is ModelHouseSection{
                let test = model as! ModelHouseSection
                self.cellCollection?.listOfModelHouseSection.append(test)
                self.cellCollection?.sectionCollectionView.reloadData()
                let listSection = self.cellCollection?.listOfModelHouseSection
                self.showModalParent?(listSection as Any)
            }
        }
        self.modalView?.returnEditData = { (model) -> () in
            if model is ModelRoom{
                let test = model as! ModelRoom
                self.listOfRoom[self.editAddRoomRow] = test
                self.createTable.reloadData()
                self.showModalParent?(self.listOfRoom)
            }else if model is ModelHouseSection{
                let test = model as! ModelHouseSection
                self.cellCollection?.listOfModelHouseSection[self.editSectionRow] = test
                self.cellCollection?.sectionCollectionView.reloadData()
                let listSection = self.cellCollection?.listOfModelHouseSection
                self.showModalParent?(listSection as Any)
            }
        }
        self.modalView?.showPicker = { (picker,true) -> () in
          // self.present(picker, animated: true, completion: nil)
            self.showPickerParent?(picker, true)
        }
        self.modalView?.showPickerAlert = { (alert,true) -> () in
            // self.present(picker, animated: true, completion: nil)
           // self.showPickerParent?(picker, true)
             self.showPickerAlertParent?(alert, true)
        }
        
    }
    
    func refeshPater(){
        if let houseEdited = house, house != nil{
            listOfRoom = houseEdited.listOfRoom!
            createTable.reloadData()
            if let listSection = houseEdited.section, houseEdited.section != nil{
                self.cellCollection?.listOfModelHouseSection = listSection
                self.cellCollection?.sectionCollectionView.reloadData()
            }
            let direction = houseEdited.direction
            var region =  MKCoordinateRegion();
            region.center = direction!.coordinate!
            // annotation.title = direction.title
            region.span.longitudeDelta = 0.004
            region.span.latitudeDelta = 0.002
            let anno = MKPointAnnotation();
            anno.coordinate = direction!.coordinate!;
        
            self.annotationLocation = anno
            self.direction = direction?.title
            createTable.reloadData()
        }
    }
    func showError(text: String) -> ModalMain{
        let modalView = Bundle.main.loadNibNamed("ModalMainView", owner: self, options: nil)![0] as? ModalMain
        modalView?.loadContentView(name: "errorText")
        modalView?.loadError(text:text)
        return modalView!
    }
}


