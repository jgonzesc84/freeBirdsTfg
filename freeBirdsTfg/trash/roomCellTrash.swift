//
//  roomCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 8/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class roomCellTrash: UITableViewCell , UITableViewDelegate , UITableViewDataSource {
   
    public var showModalParent: ((roomCell) -> ())?
    
    @IBOutlet weak var roomTableView: UITableView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }*/
    
    private func commonInit(){
        roomTableView.delegate = self
        roomTableView.dataSource = self
        roomTableView.register(UINib(nibName:"roomCell", bundle: nil), forCellReuseIdentifier: "roomCell")
        roomTableView.separatorStyle = UITableViewCell.SeparatorStyle .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : roomCell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! roomCell
       // cell.delegate = self
        // WZKInfoCloseExtractView* v = [[[NSBundle mainBundle] loadNibNamed:@"WZKInfoCloseExtractView" owner:self options:nil] firstObject];
        cell.showModal = { (text) -> () in
            /*let modalRoom = Bundle.main.loadNibNamed("addRoomModalView", owner: self, options: nil)![0] as! addRoomModalView
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            modalRoom .frame = frame
            MainHelper.theStyle(view: modalRoom)
            self.addSubview(modalRoom )*/
            self.showModalParent!(cell)
            print(text)
        }
        return cell
    }
    
  

}
