//
//  UIColor+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/15/24.
//

import UIKit

extension UIColor {
    static var atchBlack: UIColor {
        return UIColor(hex: "#000000")
    }
    
    static var atchShadowGrey: UIColor {
        return UIColor(hex: "#2E2E2E")
    }
    
    static var atchYellow: UIColor {
        return UIColor(hex: "#FCFF74")
    }
    
    static var atchGrey1: UIColor {
        return UIColor(hex: "#EFEFEF")
    }
    
    static var atchGrey2: UIColor {
        return UIColor(hex: "#D0D3D9")
    }
    
    static var atchGrey3: UIColor {
        return UIColor(hex: "#444444")
    }
    
    static var atchWhite: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var atchGreen: UIColor {
        return UIColor(hex: "#9BFF9F")
    }
    
    static var atchPink: UIColor {
        return UIColor(hex: "#FF42B3")
    }
    
    static var atchTurquoise: UIColor {
        return UIColor(hex: "#43E2D7")
    }
    
    static var atchBlue: UIColor {
        return UIColor(hex: "#007AFF")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
