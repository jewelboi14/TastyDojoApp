//
//  UIColor+Extension.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainPiggie() -> UIColor {
        return .rgb(red: 255, green: 205, blue: 173)
    }
    static func backgroundLight() -> UIColor {
        return .rgb(red: 255, green: 242, blue: 196)
    }
    static func backgroundLightDarker() -> UIColor {
        return .rgb(red: 237, green: 143, blue: 111)
    }
    
}



