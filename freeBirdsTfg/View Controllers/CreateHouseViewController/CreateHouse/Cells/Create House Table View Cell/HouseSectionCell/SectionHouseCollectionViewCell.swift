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
    @IBOutlet weak var deleteButton: Button!
    
    @IBOutlet weak var sectionImageView: UIImageView!
    
    //sectionView outletes
    @IBOutlet weak var sectionView: UIView!
    
    @IBOutlet weak var descriptionLabelSectionView: UILabel!
    @IBOutlet weak var titleLabelSectionView: UILabel!
    
    public var showModal: ((SectionHouseCollectionViewCell) -> ())?
    public var deleteCell:((SectionHouseCollectionViewCell) -> ())?
    public var model : ModelHouseSection?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        MainHelper.theStyle(view: sectionView)
   
        // Initialization code
        /**/
    }
    
    func initView(){
        hideSectionView(hide: true)
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.layer.borderWidth = 3.0
        addButton.layer.borderColor = Color.white .cgColor
        
        
        deleteButton.layer.cornerRadius = deleteButton.frame.size.height / 2
        deleteButton.backgroundColor = UIColor .AppColor.Gray.greyApp .withAlphaComponent(0.5)
        deleteButton.layer.borderColor = UIColor .white .cgColor
        deleteButton.layer.borderWidth = 1.0
        MainHelper.borderShadowRedonde(view:  deleteButton)
        
        descriptionLabelSectionView.layer.cornerRadius = 50
        titleLabelSectionView.layer.cornerRadius = 50
        MainHelper.borderShadow(view: titleLabelSectionView)
        MainHelper.borderShadow(view: descriptionLabelSectionView)
        
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        MainHelper.borderShadow(view: self)
    }
    func hideSectionView(hide: Bool){
        titleLabelSectionView.isHidden = hide
        descriptionLabelSectionView.isHidden = hide
        deleteButton.isHidden = hide
    }
    
    func setup(model : ModelHouseSection){
        self.model = model
        addView.isHidden = true
        hideSectionView(hide:false)
        titleLabelSectionView.text = self.model?.title
        descriptionLabelSectionView.text = self.model?.description
        ImageManager.shared.chechSectionImage(model){
            (model,match) in
            if (match){
                let image = model.imageData?.resizeImage(targetSize: self.sectionImageView.frame.size)
                self.sectionImageView.image = image
            }else{
                
            }
        }
    }
    func resetCell(){
        addView.isHidden = false
        hideSectionView(hide: true)
        titleLabelSectionView.text = ""
        descriptionLabelSectionView.text = ""
        sectionImageView.image = UIImage (named: "steven_playa ")
        
    }
    @IBAction func addButtonAction(_ sender: Any) {
        showModal?(self)
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteCell?(self)
    }
    
}
