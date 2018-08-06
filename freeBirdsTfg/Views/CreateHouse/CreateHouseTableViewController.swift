//
//  CreateHouseTableViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 5/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class CreateHouseTableViewController: UIView , UITableViewDelegate, UITableViewDataSource, PriceDelegate{
  
    

    @IBOutlet weak var createTable: UITableView!
    @IBOutlet var contentView: UIView!
    var price = ""
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
        
        createTable.register(UINib(nibName:"PrecioCell", bundle: nil), forCellReuseIdentifier: "PrecioCell")
        createTable.rowHeight = UITableViewAutomaticDimension
        createTable.estimatedRowHeight = 44
    }

  //  MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PrecioCell = tableView.dequeueReusableCell(withIdentifier: "PrecioCell", for: indexPath) as! PrecioCell
        cell.delegate = self
        return cell
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

   
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    //  MARK: - delegate cell Price
    
    func passPrice(priceString: String?) {
        price = priceString!
    }

   

}
