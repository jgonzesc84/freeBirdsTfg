//
//  TableViewCell.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 15/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class AddExpenseCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var model : ModelBill?
    var numberItem :Int?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "ExpenseBillCell", bundle: nil), forCellReuseIdentifier: "expenseBillCell")
//        tableView.reloadData(){
//             let  index = IndexPath(row: 0, section: 0)
//            let cell = self.tableView.cellForRow(at: index) as! ExpenseBillCell
//            cell.animation()
//            
//        }
    }
    func setupCell(model: ModelBill){
        self.model = model
    }
    
    func setupTable(){
       
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         numberItem = 0
        if let list = model?.expenses{
            numberItem = list.count
        }
        return numberItem!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseBillCell", for: indexPath) as! ExpenseBillCell
        cell.setupCell(model:model!.expenses![indexPath.row], percentage: 0.9)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let test = cell as? ExpenseBillCell{
//          //  test.animation()
//        }
    }
        
    @IBAction func addExpense(_ sender: Any) {
    }
    
   
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

