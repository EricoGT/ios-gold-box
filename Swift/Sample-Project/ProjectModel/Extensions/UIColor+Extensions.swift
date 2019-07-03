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
        return UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255), blue: CGFloat(Double(b)/255.0), alpha: CGFloat(Double(a)/255.0))
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
    
    class func random() -> UIColor {
        let red = Int.random(min: 0, max: 255)
        let green = Int.random(min: 0, max: 255)
        let blue = Int.random(min: 0, max: 255)
        return UIColor.RGBA(red, green, blue, 255)
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
    
    /** Clareia a cor, modificanco o valor dos 3 canais RGB para mais 0.2. Não modifica o canal alpha. */
    func lighten(by percentage: CGFloat = 0.2) -> UIColor {
        let cc = self.components()
        return UIColor.RGBA(min(cc.red + percentage, 1.0),
                            min(cc.green + percentage, 1.0),
                            min(cc.blue + percentage, 1.0),
                            cc.alpha)
    }
    
    /** Escurece a cor, modificanco o valor dos 3 canais RGB para menos 0.2. Não modifica o canal alpha. */
    func darken(by percentage: CGFloat = 0.2) -> UIColor {
        let cc = self.components()
        return UIColor.RGBA(max(cc.red - percentage, 0.0),
                            max(cc.green - percentage, 0.0),
                            max(cc.blue - percentage, 0.0),
                            cc.alpha)
    }
    
    //MARK: Photoshop Blend Options >> (https://github.com/Orange-W/PhotoshopBending)
    
    // Alpha Blending
    func blendAlpha(coverColor: UIColor) -> UIColor {
        let c1 = coverColor.rgbaTuple()
        let c2 = self.rgbaTuple()
        
        let c1r = CGFloat(c1.r)
        let c1g = CGFloat(c1.g)
        let c1b = CGFloat(c1.b)
        
        let c2r = CGFloat(c2.r)
        let c2g = CGFloat(c2.g)
        let c2b = CGFloat(c2.b)
        
        let r = c1r * c1.a + c2r  * (1 - c1.a)
        let g = c1g * c1.a + c2g  * (1 - c1.a)
        let b = c1b * c1.a + c2b  * (1 - c1.a)
        
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    /// Darken >> B<=A: C=B; B>=A: C=A
    func blendDarken(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return ($0 <= $1) ? $0 : $1 }
    }
    
    /// Multiply >> C = A*B
    func blendMultiply(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return $0 * $1 }
    }
    
    /// Color Burn >> C=1-(1-B)/A
    func blendColorBurn(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return 1 - (1 - $0) / $1 }
    }
    
    /// Linear Burn >> C=A+B-1
    func blendLinearBurn(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return ($1 + $0) - 1.0 }
    }
    
    /// Lighten >> B>=A: C=B; B<=A: C=A
    func blendLighten(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return ($0 >= $1) ? $0 : $1 }
    }
    
    /// Screen >> C=1-(1-A)*(1-B), 也可以写成 1-C=(1-A)*(1-B)
    func blendScreen(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return 1 - (1 - $1) * (1 - $0) }
    }
    
    /// Color Dodge >> C=B/(1-A)
    func blendColorDodge(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $1 >= 1.0 { return $1 }
            else { return min(1.0, $0 / (1 - $1)) }
        }
    }
    
    /// Linear Dodge >> C=A+B
    func blendLinearDodge(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return min(1, $1 + $0) }
    }
    
    /// Overlay >> B<=0.5: C=2*A*B; B>0.5: C=1-2*(1-A)*(1-B)
    func blendOverlay(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $0 <= 0.5 { return 2 * $1 * $0 }
            else { return 1 - 2 * (1 - $1) * (1 - $0) }
        }
    }
    
    /// Soft Light >> A<=0.5: C=(2*A-1)*(B-B*B)+B; A>0.5: C=(2*A-1)*(sqrt(B)-B)+B
    func blendSoftLight(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $1 <= 0.5 { return (2 * $1 - 1) * ($0 - $0 * $0) + $0 }
            else { return (2 * $1 - 1)*( sqrt($0) - $0) + $0 }
        }
    }
    
    /// Hard Light >> A<=0.5: C=2*A*B; A>0.5: C=1-2*(1-A)*(1-B)
    func blendHardLight(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $1 <= 0.5 { return 2 * $1 * $0 }
            else { return 1 - 2 * (1 - $1) * (1 - $0) }
        }
    }
    
    /// Vivid Light >> A<=0.5: C=1-(1-B)/(2*A); A>0.5: C=B/(2*(1-A))
    func blendVividLight(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $1 <= 0.5 { return self.fitIn((1 - (1 - $0) / (2 * $1)), ceil: 1.0) }
            else { return self.fitIn($0 / (2 * (1 - $1)), ceil: 1.0) }
        }
    }
    
    /// Linear Light >> C=B+2*A-1
    func blendLinearLight(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { return self.fitIn($0 + 2 * $1 - 1, ceil: 1.0) }
    }
    
    /// Pin Light
    /// B<2*A-1:     C=2*A-1
    /// 2*A-1<B<2*A: C=B
    /// B>2*A:       C=2*A
    func blendPinLight(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $0 <= 2 * $1 - 1 { return 2 * $1 - 1 }
            else if (2 * $1 - 1 < $0) && ($0 < 2 * $1) { return $0}
            else { return 2 * $1 }
        }
    }
    
    /// Hard Mix >> A<1-B: C=0; A>1-B: C=1
    func blendHardMix(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $1 <= 1 - $0 { return 0 }
            else { return 1 }
        }
    }
    
    /// Difference >> C=|A-B|
    func blendDifference(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { abs($1 - $0) }
    }
    
    /// Exclusion >> C = A+B-2*A*B
    func blendExclusion(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { $1 + $0 - 2 * $1 * $0  }
    }
    
    /// Subtract >> C=A-B
    func blendMinus(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) { $1 - $0 }
    }
    
    /// Divide >> C=A/B
    func blendDivision(coverColor: UIColor,alpha: CGFloat = 1.0) -> UIColor {
        return blendProcedure(coverColor: coverColor, alpha: alpha) {
            if $0 == 0{
                return 1.0
            }else {
                return self.fitIn($1 / $0, ceil: 1.0)
            }
        }
    }
    
    //MARK: PRIVATE
    
    private func fitIn(_ value: CGFloat, ceil: CGFloat = 255) -> CGFloat { return max(min(value,ceil),0) }
    
    private func fitIn(_ value: Double, ceil: CGFloat = 255) -> CGFloat { return fitIn(CGFloat(value), ceil: ceil) }
    
    private func rgbaTuple() -> (r: CGFloat, g: CGFloat, b: CGFloat,a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        r = r * 255
        g = g * 255
        b = b * 255
        
        return ((r),(g),(b),a)
    }
    
    /// Procedure
    private func blendProcedure(
        coverColor: UIColor,
        alpha: CGFloat,
        procedureBlock: ((_ baseValue: CGFloat,_ topValue: CGFloat) -> CGFloat)?
        ) -> UIColor {
        let baseCompoment = self.rgbaTuple()
        let topCompoment = coverColor.rgbaTuple()
        //
        let mixAlpha = alpha * topCompoment.a + (1.0 - alpha) * baseCompoment.a
        
        // RGB
        let mixR = procedureBlock?(
            baseCompoment.r / 255.0,
            topCompoment.r / 255.0)
            ?? (baseCompoment.r) / 255.0
        
        let mixG = procedureBlock?(
            baseCompoment.g / 255.0,
            topCompoment.g / 255.0)
            ?? (baseCompoment.g) / 255.0
        
        let mixB = procedureBlock?(
            baseCompoment.b / 255.0,
            topCompoment.b / 255.0)
            ?? baseCompoment.b / 255.0
        
        
        return UIColor.init(red:   fitIn(mixR),
                            green: fitIn(mixG),
                            blue:  fitIn(mixB),
                            alpha: mixAlpha)
    }

}
