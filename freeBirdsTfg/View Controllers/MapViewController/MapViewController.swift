//
//  MapViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 14/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import MapKit

class MapViewController: BaseViewController {

    var searchMapView : searchMapView?
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsearch: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNav(label: titleLabel, text: "Localizacion")
        setupSearchView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchView(){
        self.searchMapView = Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)![0] as? searchMapView
        self.searchMapView?.mapView = map
        let frame = CGRect(x: 0, y: 67, width: UIScreen.main.bounds.width , height: viewsearch.frame.size.height)
        self.searchMapView? .frame = frame
        self.searchMapView?.setOldFrame(frame: frame)
       // self.searchMapView?.backView .frame = CGRect(x: 0, y: 0, width: frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.searchMapView!)
       let bottomConst  = NSLayoutConstraint(item: self.searchMapView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: navView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
       // let topConstant = self.searchMapView!.topAnchor.constraint(equalTo: navView.bottomAnchor)
    //    self.view.addConstraint(topConstant)
        self.view.addConstraints([bottomConst])
      
      
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
