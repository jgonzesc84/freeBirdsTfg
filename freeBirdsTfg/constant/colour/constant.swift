//
//  constant.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 3/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    struct AppColor {
        struct Green {
            static let mindApp = UIColor().colorFromHex("BEEAE0")
            static let greenDinosaur = UIColor().colorFromHex("007a88")
        }
        
        struct Blue {
            static let blueDinosaur = UIColor().colorFromHex("1d285a")
        }
        
        struct Violet {
            
        }
        
        struct Yellow {
            
        }
        
        struct Orange {
            
        }
        
        struct Red {
            
        }
        
        struct Gray {
            static let greyApp = UIColor().colorFromHex("A49D98")
            static let greyCancel = UIColor().colorFromHex("BBBBC1")
        }
    }
    
    func colorFromHex(_ hex : String ) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb : UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat ((rgb & 0x00ff00) >> 8) / 255.0,
                            blue: CGFloat ((rgb & 0x0000ff) ) / 255.0, alpha: 1.0)
    }
}
    

    

