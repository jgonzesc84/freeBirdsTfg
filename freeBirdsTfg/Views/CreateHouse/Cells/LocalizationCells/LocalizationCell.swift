//
//  LocalizationCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 14/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
class LocalizationCell: UITableViewCell {

    @IBOutlet weak var addLocalizationView: UIView!
    @IBOutlet weak var addLocalizationViewButton: Button!
    
     public var goToMapView: ((LocalizationCell) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView(){
        MainHelper.theStyle(view: addLocalizationView)
        addLocalizationViewButton.layer.cornerRadius = addLocalizationViewButton.frame.size.height / 2
        addLocalizationViewButton.layer.borderWidth = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func addLocalizationButtonAction(_ sender: Any) {
        //desde aqui nah otro closure
      /*  let vc = CreateHouse(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)*/
        goToMapView?(self)
        
    }
    
}
