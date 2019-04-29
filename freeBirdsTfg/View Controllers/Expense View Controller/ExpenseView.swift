//
//  ExpenseView.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 12/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import UIKit

class ExpenseView: BaseViewController , UITableViewDelegate, UITableViewDataSource, RefreshHouseData{
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var controller : ExpenseController?
    var arrayBill : Array<ModelBill>?

    override func viewDidLoad() {
        
        super.viewDidLoad()
         controller = ExpenseController(view:self)
         initView()
         setuptable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    func initView(){
        prepareNavRoot(label: titlelabel, text: "Gastos")
        MainHelper.navStyle(view:navView)
         arrayBill=HouseManager.sharedInstance.house?.listOfBill
        controller?.setupBill(listOfBill:arrayBill!)
       
    }

    func setuptable(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle .none
        self.tableView.register(UINib(nibName:"AddExpenseCell", bundle: nil), forCellReuseIdentifier: "addExpense")
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBill!.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return (controller?.drawCell(tableView: tableView, indexPath: indexPath))!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           controller?.didSelectRow(tableView: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func refresh(){
        controller?.actualize()
    }
}
