//
//  SectionHouseCollectionViewCell.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 13/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class SectionHouseCollectionViewCell: UICollectionViewCell {
 //addView outletes
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var addView: UIView!
    
    
    //sectionView outletes
    @IBOutlet weak var sectionView: UIView!
    
    @IBOutlet weak var descriptionLabelSectionView: UILabel!
    @IBOutlet weak var titleLabelSectionView: UILabel!
    
    public var showModal: ((SectionHouseCollectionViewCell) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        MainHelper.theStyle(view: sectionView)
        // Initialization code
        /**/
    }
    
    func initView(){
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.layer.borderWidth = 3.0
        addButton.layer.borderColor = Color.white .cgColor
        titleLabelSectionView.isHidden = true
        descriptionLabelSectionView.isHidden = true
        descriptionLabelSectionView.layer.cornerRadius = 50
        titleLabelSectionView.layer.cornerRadius = 50
        MainHelper.borderShadow(view: titleLabelSectionView)
        MainHelper.borderShadow(view: descriptionLabelSectionView)
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        MainHelper.borderShadow(view: self)
    }
    
    func setup(model : ModelHouseSection){
        addView.isHidden = true
        titleLabelSectionView.isHidden = false
        descriptionLabelSectionView.isHidden = false
        titleLabelSectionView.text = model.title
        descriptionLabelSectionView.text = model.description
    }
    func resetCell(){
        addView.isHidden = false
        titleLabelSectionView.isHidden = true
        descriptionLabelSectionView.isHidden = true
        titleLabelSectionView.text = ""
        descriptionLabelSectionView.text = ""
        
    }
    @IBAction func addButtonAction(_ sender: Any) {
        showModal?(self)
        
    }
    

}
