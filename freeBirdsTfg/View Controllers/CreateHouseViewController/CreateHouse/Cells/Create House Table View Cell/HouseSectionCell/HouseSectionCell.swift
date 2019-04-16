//
//  HouseSectionCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 12/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit

class HouseSectionCell: UITableViewCell, UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
   
    public var listOfModelHouseSection = Array<ModelHouseSection>()
    public var showModalToParent: ((Any) -> ())?
   
    public var maxLimit  = 0
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
        calculatetItemSize()
    }
    func initData(){
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        sectionCollectionView.register(UINib(nibName:"SectionHouseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionHouseCollectionViewCell")
      // sectionCollectionView.register(MirameCollectionViewCell.self, forCellWithReuseIdentifier: "MirameCollectionViewCell")
        
    }
    
    func calculatetItemSize(){
        let cellScaling: CGFloat = 0.8
        let parentSize = self.frame
        let cellWidth = floor(parentSize.width * cellScaling)
        let cellHeight = floor(parentSize.height * cellScaling)
        let insetX = (parentSize.width - cellWidth) / 2.0
        let insetY  = (parentSize.height - cellHeight) / 2.0
        let layout = sectionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        sectionCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var limit = listOfModelHouseSection.count
        if(limit > 0){
            limit += 1
        }else{
            limit = 1
        }
        
        maxLimit = limit
        return limit;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : SectionHouseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionHouseCollectionViewCell", for: indexPath) as! SectionHouseCollectionViewCell
       cell.resetCell()
        let total = listOfModelHouseSection.count
        if(total > 0 && indexPath.row < (maxLimit) - 1){
          cell.setup(model: listOfModelHouseSection[indexPath.row])
          cell.deleteCell = { (cell) -> () in
          self.listOfModelHouseSection.remove(at: indexPath.row)
            //OPTION A
            // avisamos a CreateHouseTableView que follón!!!
            self.showModalToParent?(self.listOfModelHouseSection)
            self.sectionCollectionView.performBatchUpdates({
                let indexSet = IndexSet(integersIn: 0...0)
                self.sectionCollectionView.reloadSections(indexSet)
            }, completion: nil)
          //OPTION B
           /* UIView.transition(with: self.sectionCollectionView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.sectionCollectionView.reloadData()
            }, completion: nil)*/
        }
        }
        
        cell.showModal = { (collectionCell) -> () in
            self.showModalToParent?(collectionCell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let position = indexPath.row
        if(position != (maxLimit) - 1){
            self.showModalToParent?(position)
            
            
        }
        
    }
    
    //MARK collectionViewFlow Layout encargado de decirle de que tamañoi son las celdas y que espacio hay entre ellas
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let availableWidth = self.frame.size.width - 35
        let widthPerItem = availableWidth / 1
        let heightPerItem = self.frame.size.height - 35
        return CGSize(width: widthPerItem, height: heightPerItem)
}*/

}
