//
//  colorTest.swift
//  freeBirdsTfg
//
//  Created by Javier Gonzalez Escudero on 16/04/2019.
//  Copyright © 2019 javier gonzalez escudero. All rights reserved.
//

import Foundation

enum colorExpense : String{
   
    case color1 = "4EAFDC"
    case color2 = "1E3881"
    case color3 = "95B6DA"
    case color4 = "1E253F"
    case color5 = "DDDCE3"
    case color6 = "D9BAA9"
    case color7 = "53552E"
    case color8 = "9FCB71"
    case color9 = "6641A3"
    case color10 = "5A5954"
    case color11 = "FC6D69"
    case color12 = "2C805C"
    case color13 = "480913"
    case color14 = "B5DCD3"
    case color15 = "FC6B35"
    case color16 = "C2732C"
    case color17 = "0E3C2C"
    case color18 = "BEA7D9"
    case color19 = "E5192C"
    case color20 = "5CD1D2"

}

enum icoExpense : String{
    
    case ico1 = "ico_agua"
    case ico2 = "ico_bote"
    case ico3 = "ico_casa"
    case ico4 = "ico_chewaca"
    case ico5 = "ico_decoracion"
    case ico6 = "ico_dinero"
    case ico7 = "ico_fiesta"
    case ico8 = "ico_gas"
    case ico9 = "ico_herramientas"
    case ico10 = "ico_internet"
    case ico11 = "ico_jardin"
    case ico12 = "ico_luz"
    case ico13 = "ico_mantenimiento"
    case ico14 = "ico_mobil"
    case ico15 = "ico_stark"
    case ico16 = "ico_tele"
    case ico17 = "ico_viaje"
    
}

extension colorExpense: CaseIterable {}
extension icoExpense : CaseIterable{}
