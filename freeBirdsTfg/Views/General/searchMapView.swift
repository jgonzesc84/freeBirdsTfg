//
//  searchMapView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 14/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import MapKit

class searchMapView: UIView , UITableViewDataSource, UITableViewDelegate ,UISearchBarDelegate {
    
    
    @IBOutlet weak var backViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet var mainViewII: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchDirectionBar: UISearchBar!
    @IBOutlet weak var directionTable: UITableView!
    @IBOutlet weak var directionTableHeightConstant: NSLayoutConstraint!
    // weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    let searchController = UISearchController(searchResultsController: nil)
    var oldFrame : CGRect?
    
    override func awakeFromNib() {
        super .awakeFromNib()
       // commonInit()
        initView()
        
        
    }
   /* override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        initView()
       
    }
    
   func commonInit(){
        Bundle.main.loadNibNamed("searchMapView", owner: self, options: nil)
        addSubview(mainViewII)
        mainViewII.frame = self.bounds
        mainViewII.autoresizingMask = [.flexibleHeight , .flexibleWidth]
    }*/
    func initView(){
        directionTable.register(UINib(nibName: "searchMapCell", bundle: nil), forCellReuseIdentifier: "searchMapCell")
        directionTable.separatorStyle = UITableViewCellSeparatorStyle .none
         searchDirectionBar.delegate = self
        directionTable.delegate = self
        directionTable.dataSource = self
        directionTableHeightConstant.constant = 0
        dismissViewSetup()
        backViewHeightConstant.constant = 0
        searchTextStyle()
    }
   
    func searchTextStyle(){
        let textFieldInsideUISearchBar = searchDirectionBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor .AppColor.Gray.greyApp
        textFieldInsideUISearchBar?.font = UIFont.AppFont.middleFont.middlWord
        
       /* let textFieldInsideUISearchBarLabel = searchDirectionBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = UIColor.whiteColor()*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : searchMapCell = tableView.dequeueReusableCell(withIdentifier: "searchMapCell") as! searchMapCell
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.directionLabel.text = selectedItem.title
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOf = matchingItems.count
        directionTableHeightConstant.constant = CGFloat(numberOf * 44)
        
        return numberOf
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        print(selectedItem)
        //comunicar con el mapa
        // handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
        //  dismissViewControllerAnimated(true, completion: nil)
        directionTable.isHidden = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.00
    }
    func setOldFrame(frame : CGRect){
        oldFrame = frame
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.count > 0 ){
            if (backViewHeightConstant.constant == 0) {
                backViewHeightConstant.constant = UIScreen.main.bounds.height
            }
            let frame = UIScreen.main.bounds
            self.frame = CGRect(x: (oldFrame?.origin.x)! , y: (oldFrame?.origin.y)!, width: frame.size.width, height: frame.size.height)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchText
            request.region = (self.mapView?.region)!
            let search = MKLocalSearch(request: request)
            
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                if(searchBar.text?.count == 0){
                    self.matchingItems.removeAll()
                    self.directionTable.reloadData()
                }else{
                    self.matchingItems = response.mapItems
                    self.directionTable.reloadData()
                }
               
            }
        }else{
            self.frame = oldFrame!
            backViewHeightConstant.constant = 0
            self.matchingItems.removeAll()
            self.directionTable.reloadData()
        }
       
    
    
}
    
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    
    func dismissViewSetup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView?.addGestureRecognizer(tap)
        backView?.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        backViewHeightConstant.constant = 0
        self.matchingItems.removeAll()
        self.directionTable.reloadData()
        
    }
}

extension searchMapView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.directionTable.reloadData()
        }
    }
}


