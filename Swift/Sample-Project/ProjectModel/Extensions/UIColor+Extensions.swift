//
//  UIColor+Extensions.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 27/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

struct ColorComponents {
    var red : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    //
    var hue : CGFloat = 0.0
    var saturation : CGFloat = 0.0
    var brightness : CGFloat = 0.0
}

//enum CustomColor {
//    case day
//    case night
//}
//
//extension CustomColor: RawRepresentable {
//    typealias RawValue = UIColor
//
//    init?(rawValue: RawValue) {
//        switch rawValue {
//        case UIColor.init(red: 1, green: 1, blue: 1, alpha: 1) : self = .day
//        case UIColor.init(red: 0, green: 0, blue: 0, alpha: 1) : self = .night
//        default: return nil
//        }
//    }
//
//    var rawValue: RawValue {
//        switch self {
//        case .day: return UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//        case .night: return UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
//        }
//    }
//}

extension UIColor {

    /** Cria uma nova cor (UIColor) utilizando o valor RGBA parâmetro (0~1). */
    class func RGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        let r = red < 0.0 ? 0.0 : (red > 1.0 ? 1.0 : red)
        let g = green < 0.0 ? 0.0 : (green > 1.0 ? 1.0 : green)
        let b = blue < 0.0 ? 0.0 : (blue > 1.0 ? 1.0 : blue)
        let a = alpha < 0.0 ? 0.0 : (alpha > 1.0 ? 1.0 : alpha)
        //
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /** Cria uma nova cor (UIColor) utilizando o valor RGBA parâmetro (0~255). */
    class func RGBA(_ R:Int, _ G:Int, _ B:Int, _ A:Int) -> UIColor {
        let r = R < 0 ? 0 : (R > 255 ? 255 : R)
        let g = G < 0 ? 0 : (G > 255 ? 255 : G)
        let b = B < 0 ? 0 : (B > 255 ? 255 : B)
        let a = A < 0 ? 0 : (A > 255 ? 255 : A)
        //
        return UIColor.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a/255))
    }
    
    /** Cria uma nova cor (UIColor) utilizando o valor hexa parâmetro. */
    class func color(hex:UInt) -> UIColor {
        let r = CGFloat.init((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat.init((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat.init((hex & 0xFF)) / 255.0
        //
        return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /** Cria uma nova cor (UIColor) utilizando o valor hexa textual parâmetro. */
    class func color(hexSTR:String) -> UIColor {
        
        let colorString = hexSTR.replacingOccurrences(of: "#", with: "")
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        switch colorString.count {
            
        case 3: // #RGB
            alpha = 1.0
            red   = self.colorComponent(fromText: colorString, start: 0, length: 1)
            green = self.colorComponent(fromText: colorString, start: 1, length: 1)
            blue  = self.colorComponent(fromText: colorString, start: 2, length: 1)
            
        case 4: // #ARGB
            alpha = self.colorComponent(fromText: colorString, start: 0, length: 1)
            red   = self.colorComponent(fromText: colorString, start: 1, length: 1)
            green = self.colorComponent(fromText: colorString, start: 2, length: 1)
            blue  = self.colorComponent(fromText: colorString, start: 3, length: 1)
            
        case 6: // #RRGGBB
            alpha = 1.0
            red   = self.colorComponent(fromText: colorString, start: 0, length: 2)
            green = self.colorComponent(fromText: colorString, start: 4, length: 2)
            blue  = self.colorComponent(fromText: colorString, start: 6, length: 2)
            
        case 8: // #AARRGGBB
            alpha = self.colorComponent(fromText: colorString, start: 0, length: 2)
            red   = self.colorComponent(fromText: colorString, start: 2, length: 2)
            green = self.colorComponent(fromText: colorString, start: 4, length: 2)
            blue  = self.colorComponent(fromText: colorString, start: 6, length: 2)
            
        default:
            alpha = 1.0
            red   = 0.0
            green = 0.0
            blue  = 0.0
        }
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private class func colorComponent(fromText:String, start:Int, length:Int) -> CGFloat {
        let substring = fromText.substring(from: start, length: length)
        let fullHex = length == 2 ? substring : String.init(format: "%@%@", substring, substring)
        var hexComponent:UInt32 = UInt32.init()
        Scanner.init(string: fullHex).scanHexInt32(&hexComponent)
        //
        return CGFloat.init(hexComponent) / 255.0
    }
    
    /** Retorna os componentes RBGA da cor parâmetro, além do Hue, Saturation and Brightness. */
    func components() -> ColorComponents {
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0, h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        
        var colorC = ColorComponents.init()
        colorC.red = r
        colorC.green = g
        colorC.blue = b
        colorC.alpha = a
        //
        colorC.hue = h
        colorC.saturation = s
        colorC.brightness = v
        //
        return colorC
        
    }

}
