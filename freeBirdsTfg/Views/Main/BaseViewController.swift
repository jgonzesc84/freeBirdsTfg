//
//  BaseViewController.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 10/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import UIKit
import Material

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func prepareDelegate(){
    
    }
    //  MARK: - delegate roomexpandibleCell
    func callModalView() {
        
    }
    
    func animationButtons(button:UIView){
        UIView.animate(withDuration: 1) {
            button.center.y -= self.view.bounds.height/4
        }
        }
    
    func prepareNav(label : UILabel , text: String){
        label.text = text
        let backButton = Button(type : .custom)
        backButton.pulseColor = UIColor.AppColor.Gray.greyApp
        backButton.setImage(#imageLiteral(resourceName: "left_angle_bracket"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem?.customView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(goBack)))
        
        
    }
    
    
    
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
