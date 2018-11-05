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
import MapKit

private let sharedHelper = MainHelper()

class MainHelper{
    
    
    class var sharedInstance: MainHelper {
            return sharedHelper
  }
    /**
  @func Metodo que da un estilo por defecto a cualquier vista y subVista que contenga
 **/
    static func theStyle(view: UIView){
      
        for subView in view.subviews {
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
            case "UITextView":
                let textView = subView as! UITextView
                giveMeStyle(textView: textView)
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
    static func dissableButtonCreate(button: Button){
         UIView.animate(withDuration: 1) {
        button.isEnabled = false;
        button.layer.borderColor = UIColor .AppColor.Gray.greyCancel .cgColor
        button.backgroundColor = UIColor .white
        button.titleColor = UIColor.AppColor.Gray.greyCancel
        }
    }
    static func enabledButton(button: Button){
        button.isEnabled = true;
        button.layer.borderColor = UIColor .AppColor.Green.mindApp .cgColor
        button.titleColor = UIColor.AppColor.Green.mindApp
    }
    static func enabledButtonCreate(button: Button){
         UIView.animate(withDuration: 1) {
        button.isEnabled = true;
        button.backgroundColor = UIColor.AppColor.Green.mindApp
        button.titleColor = UIColor .white
        }
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
    static func giveMeWhiteStyleLabel(label: UILabel){
        label.textColor = UIColor .white
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
    
    static func giveMeStyle(textView: UITextView){
        textView.font = UIFont.AppFont.middleFont.middlWord
        textView.textColor = UIColor.AppColor.Gray.greyApp
    }
    
    static func borderShadow(view : UIView){
        view.layer.cornerRadius = 3.0
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.clipsToBounds = false
    }
    
    static func borderShadowRedonde(view : UIView){
        view.layer.width = 2
        view.layer.shadowColor = UIColor .black .cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen .main.scale
    }
    
    
    static func acceptButtonStyle(button : Button){
    button.layer.cornerRadius = 3.0
    button.backgroundColor = UIColor .AppColor.Green.mindApp
    button.titleLabel?.font = UIFont.AppFont.middleFont.middlWord!
    button.titleColor = UIColor .white
    button.pulseColor = UIColor.AppColor.Gray.greyApp
    }
    
    static func circleButton(button : UIButton){
        
        button.layer.cornerRadius = button.frame.height / 2
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
    
    static func parseAddress(selectedItem:CLPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
}
/**
 @extension De Uiview para ocultar el teclado cunado se pulse sobre
 cualquier superficie de la vista.
 **/
extension UIView {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.pepe))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func pepe() {
        self.endEditing(true)
    }
}
/**
 @extension Extension que localiza el topViewController se usa
 para poder añadir las vistas modales por encima de todas las demás
 **/
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

/**
 @extension Extension que dependiendo del tamaño del string da unaas medidas para el label contenedor
 **/

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
