//
//  mainHelper.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 8/9/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit
import Material

private let sharedHelper = MainHelper()

class MainHelper{
    
    
    class var sharedInstance: MainHelper {
            return sharedHelper
  }
    
    static func theStyle(view: UIView){
      
        for subView in view.subviews {
            //String(describing: YourType.self)
             let name = String(describing: type(of: subView))
            switch name{
            case "UITextField":
                let textField = subView as! UITextField
                giveMeStyle(textField: textField)
            break
            case "Button":
            let button = subView as! Button
            giveMeStyle(button: button)
            break
            case "UILabel":
             let label = subView as! UILabel
             giveMeStyle(label: label)
            break
            default:
            
            break
            
        }
        
        }
    }
    
    
    static func dissableButton(button: Button){
       button.isEnabled = false;
       button.layer.borderColor = UIColor .AppColor.Gray.greyCancel .cgColor
       button.titleColor = UIColor.AppColor.Gray.greyCancel
        
    }
    static func enabledButton(button: Button){
        button.isEnabled = true;
        button.layer.borderColor = UIColor .AppColor.Green.mindApp .cgColor
        button.titleColor = UIColor.AppColor.Green.mindApp
    }
    
   static func giveMeStyle(textField: UITextField){
        textField.font = UIFont.AppFont.middleFont.middlWord
        textField.textColor = UIColor.AppColor.Gray.greyApp
        textField.layer.borderColor = UIColor.AppColor.Green.mindApp .cgColor
        textField.layer.borderWidth = 3.0
        textField.tintColor = UIColor.AppColor.Green.mindApp
         textField.textAlignment = NSTextAlignment.center
    
    }
   static func giveMeStyle(label: UILabel){
        label.textColor = UIColor .AppColor.Gray.greyApp
        label.font = UIFont .AppFont.middleFont.middlWord
        
    }
    
   static func giveMeStyle(button : Button){
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.AppColor.Gray.greyApp .cgColor
        button.layer.borderWidth = 5.0
        button.titleLabel?.font = UIFont.AppFont.middleFont.middlWord!
        button.titleColor = UIColor.AppColor.Green.mindApp
        button.pulseColor = UIColor.AppColor.Gray.greyApp
    }
    
    static func borderShadow(view : UIView){
        view.layer.cornerRadius = 3.0
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.clipsToBounds = false
    }
    
    static func navStyle(view : UIView){
        view.backgroundColor = UIColor .white
        for item in view.subviews {
            var label : UILabel?
            let separator : UIView?
            let name = String(describing: type(of: item))
            switch name{
            case "UIView":
                 separator = item
                 separator?.backgroundColor = UIColor .AppColor.Green.mindApp
                /* var frame = separator?.frame
                 frame?.size.height = 50
                 separator?.frame = frame!
                 separator?.translatesAutoresizingMaskIntoConstraints = false
                 view.addConstraint(NSLayoutConstraint(item: separator!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 100))
                 view.addConstraint(NSLayoutConstraint(item: separator!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 67))
                 view.addConstraint(NSLayoutConstraint(item: separator!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 67))*/
                
                break
            case "UILabel":
                label = item as? UILabel
                label?.font = UIFont.AppFont.titleFont.navTitleFont
                label?.textColor = UIColor .AppColor.Green.mindApp
                label?.textAlignment = .center
                label?.translatesAutoresizingMaskIntoConstraints = false
               //view.addConstraint(NSLayoutConstraint(item: label!, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
               // view.addConstraint(NSLayoutConstraint(item: label!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 20))
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 20))
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 28))
                break
            default:
                
                break
                
            }
            
        }
        
    }
    
}
