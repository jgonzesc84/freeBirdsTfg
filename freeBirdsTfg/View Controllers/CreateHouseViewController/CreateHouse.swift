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
 
    public var modalView : addRoomModalView?
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
      //  MainHelper.dissableButton(button: buttonAccept)
       
        
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
    
   /* func prepareNav(label : UILabel){
        titlelabel .text = "Crea tu Casa"
        let backButton = Button(type : .custom)
        backButton.pulseColor = UIColor.AppColor.Gray.greyApp
        backButton.setImage(#imageLiteral(resourceName: "left_angle_bracket"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(goBack)))
        
     
    }*/

   /* func setNavBarToTheView() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Camera");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: nil);
        navItem.leftBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: true);
    }*/
    
    
   /* @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }*/
    
    func heardCell(){
        createHouseTable.showModalParent = { (sender) -> () in
           
            switch sender {
            case is roomCell:
                self.prepareModal()
                self.modalView?.setupModal(mode: true)
                self.view.addSubview(self.modalView!)
                break;
            case is SectionHouseCollectionViewCell:
                self.prepareModal()
                self.modalView?.setupModal(mode: false)
                self.view.addSubview(self.modalView!)
                break;
            case is MapViewController:
                let vc =  sender as! MapViewController
                self.navigationController?.pushViewController(vc, animated: true)
                break;
            case is PrecioCell:
                print("precio")
                break;
            default:
                break;
            }
           
        }
    }
    
    func prepareModal(){
        self.modalView = Bundle.main.loadNibNamed("addRoomModalView", owner: self, options: nil)![0] as? addRoomModalView
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.modalView? .frame = frame
        MainHelper.theStyle(view: self.modalView!)
        self.heardModalView()
    }
    
    func heardModalView(){
        
        self.modalView?.returnData = { (model) -> () in
            
            if model is ModelRoom{
                let test = model as! ModelRoom
                self.createHouseTable.listOfRoom.append(test)
                self.createHouseTable.createTable.reloadData()
            }else if model is ModelHouseSection{
                let test = model as! ModelHouseSection
                self.createHouseTable.cellCollection?.listOfModelHouseSection.append(test)
                self.createHouseTable.cellCollection?.sectionCollectionView.reloadData()
            }
        }
    }
    func heardMapView(){
    
    }
    
    
    @IBAction func acceptActionButton(_ sender: Any) {
        
        
    }
    //  MARK: - delegate roomexpandibleCell
 
  
  /*
    secondViewController.buttonAction = {(text) -> () in
    self.textLabel.text = text
    return secondViewController.dismiss(animated: true, completion: nil)
    }
 */

}
