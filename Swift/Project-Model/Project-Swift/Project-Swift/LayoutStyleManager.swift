//
//  LayoutManager.swift
//  Project-Swift
//
//  Created by Erico GT on 04/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

enum AppStyle: Int {
    case Default    = 0
    case Light      = 1
    case Dark       = 2
    case Special    = 3
}

class LayoutStyleManager:NSObject{
    
    //Properties:
    var style:AppStyle
    
    //EXEMPLOS: modifique conforme necessidade:
    var colorView_SuperLight:UIColor
    var colorView_Light:UIColor
    var colorView_Normal:UIColor
    var colorView_Dark:UIColor
    var colorView_SuperDark:UIColor
    //
    var colorView_RedDefault:UIColor
    var colorView_RedDark:UIColor
    //
    var colorView_GreenDefault:UIColor
    var colorView_GreenDark:UIColor
    
    //Textos
    var colorText_White:UIColor
    //
    var colorText_GrayDefault:UIColor
    var colorText_GrayDark:UIColor
    //
    var colorText_RedDefault:UIColor
    var colorText_RedDark:UIColor
    //
    var colorText_GreenDefault:UIColor
    var colorText_GreenDark:UIColor
    
    //Initializers:
    override init(){
        self.style = .Default
        //
        colorView_SuperLight = UIColor.white
        colorView_Light = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        colorView_Normal = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        colorView_Dark = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        colorView_SuperDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        //
        colorView_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        colorView_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        //
        colorView_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        colorView_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        
        //Textos
        colorText_White = UIColor.white
        //
        colorText_GrayDefault = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        colorText_GrayDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        //
        colorText_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        colorText_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        //
        colorText_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        colorText_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
    }
    
    func setStyle(_ style:AppStyle){
        
        //MARK: Para criar aplicações com set de estilos, implementar as variações abaixo:
        switch style {
        case .Default, .Light, .Dark, .Special:
            self.style = .Default
            //
            colorView_SuperLight = UIColor.white
            colorView_Light = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            colorView_Normal = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            colorView_Dark = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            colorView_SuperDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            //
            colorView_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            colorView_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            //
            colorView_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
            colorView_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
            
            //Textos
            colorText_White = UIColor.white
            //
            colorText_GrayDefault = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            colorText_GrayDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            //
            colorText_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            colorText_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            //
            colorText_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
            colorText_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
            
            //        case .Light:
            //            break
            //
            //        case .Dark:
            //            break
            //
            //        case .Special:
            //            break
            
        }
        
    }
    
}
