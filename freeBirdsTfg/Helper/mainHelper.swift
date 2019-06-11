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
    
    static func cancelButton(_ button: Button){
        button.layer.cornerRadius = button.frame.size.width / 2
        //button.backgroundColor = UIColor .AppColor.Red.redCancel
        button.image = UIImage(named:"ico_delete_classic")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
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
    static func giveMeStyle(button : Button, _ borderWith: CGFloat, _ cornerRadius: CGFloat){
        button.layer.cornerRadius = cornerRadius
        button.layer.borderColor = UIColor.AppColor.Gray.greyApp .cgColor
        button.layer.borderWidth = borderWith
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
    static func noBorderShadow(view : UIView){
        view.layer.cornerRadius = 0.0
        view.layer.shadowRadius = 0
        view.layer.shadowOpacity = 0
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
    static func borderShadowRedondNotRadius(view : UIView){
        view.layer.width = 2
        view.layer.shadowColor = UIColor .black .cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1
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
    
    static func circleView(view : UIView){
    view.layer.cornerRadius = view.layer.frame.height / 2
        
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
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 20))
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 20))
                view.addConstraint(NSLayoutConstraint(item: label!, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 28))
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
 @extension Extension que dependiendo del tamaño del string da unas medidas para el label contenedor
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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UINavigationController {
    /**
     It removes all view controllers from navigation controller then set the new root view controller and it pops.
     
     - parameter vc: root view controller to set a new
     */
    func initRootViewController(vc: UIViewController,  duration: CFTimeInterval = 0.3) {
    
        self.addTransition( duration: duration)
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition( duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
       
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type =  CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func resizeCI(size:CGSize) -> UIImage? {
        let scale = (Double)(size.width) / (Double)(self.size.width)
        let image = UIKit.CIImage(cgImage:self.cgImage!)
        
        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value:scale), forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey:kCIInputAspectRatioKey)
        let outputImage = filter.value(forKey: kCIOutputImageKey) as! UIKit.CIImage
        
        let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        let resizedImage = UIImage(cgImage: context.createCGImage(outputImage, from: outputImage.extent)!)
        return resizedImage
    }
    /*
     myImage = myImage.resizeWithWidth(700)!
     Now next you can still compress it using compression ratio of your choice
     let compressData = UIImageJPEGRepresentation(myImage, 0.5) //max value is 1.0 and minimum is 0.0
     let compressedImage = UIImage(data: compressData!)

 */
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
