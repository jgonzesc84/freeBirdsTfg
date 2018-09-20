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
    
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet var mainViewII: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchDirectionBar: UISearchBar!
    @IBOutlet weak var directionTable: UITableView!
    
    @IBOutlet weak var directionTableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var backViewHeightConstant: NSLayoutConstraint!
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    let searchController = UISearchController(searchResultsController: nil)
    var oldFrame : CGRect?
      public var getDirection: ((MKMapItem) -> ())?
    
    override func awakeFromNib() {
        super .awakeFromNib()
        initView()
    }
    
  
    func initView(){
        directionTable.register(UINib(nibName: "searchMapCell", bundle: nil), forCellReuseIdentifier: "searchMapCell")
        directionTable.separatorStyle = UITableViewCellSeparatorStyle .none
         searchDirectionBar.delegate = self
        directionTable.delegate = self
        directionTable.dataSource = self
        directionTableHeightConstant.constant = UIScreen.main.bounds.height / 2
        dismissViewSetup()
        backViewHeightConstant.constant = 0
        searchTextStyle()
        searchDirectionBar.layer.borderColor = UIColor .white .cgColor
        searchDirectionBar.layer.borderWidth = 3.00
        self.directionTable.rowHeight = UITableViewAutomaticDimension;
        self.directionTable.estimatedRowHeight = 44.0
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
       // directionTableHeightConstant.constant = CGFloat(numberOf * 44)
        
        return numberOf
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        searchDirectionBar.text = selectedItem.title
        self.getDirection?(matchingItems[indexPath.row])
        directionTable.isHidden = true
        backViewHeightConstant.constant = 0
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: searchDirectionBar.frame.size.height)
        searchDirectionBar.resignFirstResponder()
      
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
            let space = searchText.contains(" ")
            let coma = searchText.contains(",")
            let numbersRange = searchText.rangeOfCharacter(from: .decimalDigits)
            let hasNumbers = (numbersRange != nil)
            if( space || coma || hasNumbers){
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
                        if (self.directionTable.isHidden){
                            self.directionTable.isHidden = false
                        }
                        self.matchingItems = response.mapItems
                        self.directionTable.reloadData()
                    }
                    
                }
            }
            
        }else{
            self.frame = oldFrame!
            backViewHeightConstant.constant = 0
            self.matchingItems.removeAll()
            self.directionTable.reloadData()
        }
       
    
    
}
    
    
    func parseAddress(selectedItem:CLPlacemark) -> String {
        
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
          directionTable.isHidden = true
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: searchDirectionBar.frame.size.height)
        self.matchingItems.removeAll()
        self.directionTable.reloadData()
        self.searchDirectionBar.resignFirstResponder()
        
    }
}

/*extension searchMapView : UISearchResultsUpdating {
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
}*/


