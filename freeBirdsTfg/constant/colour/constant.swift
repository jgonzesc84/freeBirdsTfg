//
//  constant.swift
//  freeBirdsTfg
//
//  Created by javier gonzalez escudero on 3/8/18.
//  Copyright © 2018 javier gonzalez escudero. All rights reserved.
//

import Foundation
import UIKit

class constant{
    static let billCellHeight = 70.0
    static let sectionExpenseHeight = 100.0
    static let billheaderHeight = 80
    static let billPaddingTop = 40
    static let formatBillDate = "MM.yyyy"
    static let formatMeesageDate = "dd/MM/yyyy HH:mm"
    
    static let stateOpendRequest = "abierta"
    static let stateAcceptRequest = "aceptada"
    static let statcDeclineRequest = "rechazada"
    static let stateFinishedRequest = "finalizada"
}
extension UIColor {
    
    
    struct AppColor {
        struct Green {
            static let mindApp = UIColor().colorFromHex("BEEAE0")
            static let greenDinosaur = UIColor().colorFromHex("007a88")
        }
        
        struct Blue {
            //#3882BC rgba(191, 246, 248, 0.28)
            static let blueDinosaur = UIColor().colorFromHex("1d285a")
            static let blueHouse = UIColor().colorFromHex("#3882BC")
            static let bluePastel = UIColor(red: 191, green: 246, blue: 248, alpha:1)
            static let bluetest = UIColor(red: 192, green: 246, blue: 248, alpha: 0.28)
        }
        
        struct Violet {
            
        }
        
        struct Yellow {
            
        }
        
        struct Orange {
             static let orangeNeon = UIColor().colorFromHex("F46420")
        }
        
        struct Red {
            static let redCancel = UIColor().colorFromHex("FB989A")
        }
        
        struct Gray {
            static let greyApp = UIColor().colorFromHex("A49D98")
            static let greyCancel = UIColor().colorFromHex("BBBBC1")
            static let greyStrong = UIColor().colorFromHex("#333333")
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
    

    

