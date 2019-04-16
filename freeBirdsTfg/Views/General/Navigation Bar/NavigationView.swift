//
//  NavigationView.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 4/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material
import Lottie

class NavigationView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: Button!
    @IBOutlet weak var rightButton: Button!
    @IBOutlet weak var separatorView: UIView!
    weak var delegate: backDelegate?
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit(){
        Bundle.main.loadNibNamed("Navigation", owner: self, options: nil)
        addSubview(contentView!)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        lottieAnimationBack()
        iniView()
    }
    
    
    func iniView(){
        if hasTopNotch{
            topConstraint.constant = 30;
        }
    }

    func lottieAnimationBack(){
        let animationView = LOTAnimationView(name: "backAnimation")
        let frame = self.leftButton.frame
        animationView.frame = CGRect(x:0, y: 0 , width: frame.size.width, height: frame.size.height )
        animationView.contentMode = .scaleAspectFit
        self.leftButton.addSubview(animationView)
        self.leftButton.sendSubviewToBack(animationView )
        animationView.backgroundColor = UIColor .white
        animationView.play()
        animationView.loopAnimation = false
        
    }
    
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
       
     delegate?.goBack()
        
    }
    
}

protocol backDelegate: class {
    func goBack()
}

extension NavigationView{
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
           
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }

}
