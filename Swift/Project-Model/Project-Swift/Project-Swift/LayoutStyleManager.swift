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
    var colorBackgroundScreen_Light:UIColor
    var colorBackgroundScreen_Normal:UIColor
    var colorBackgroundScreen_Dark:UIColor
    var colorBackgroundScreen_Other:UIColor
    //
    var colorTextLabel_Light:UIColor
    var colorTextLabel_Normal:UIColor
    var colorTextLabel_Dark:UIColor
    var colorTextLabel_Other:UIColor
    var colorTextLabel_White:UIColor
    var colorTextLabel_Black:UIColor
    //
    var colorBackgroundButton_Light:UIColor
    var colorBackgroundButton_Normal:UIColor
    var colorBackgroundButton_Dark:UIColor
    var colorBackgroundButton_Other:UIColor
    
    //Initializers:
    override init(){
        style = .Default
        //
        colorBackgroundScreen_Light = UIColor.lightGray
        colorBackgroundScreen_Normal = UIColor.gray
        colorBackgroundScreen_Dark = UIColor.darkGray
        colorBackgroundScreen_Other = UIColor.black
        //
        colorTextLabel_Light = UIColor.lightGray
        colorTextLabel_Normal = UIColor.gray
        colorTextLabel_Dark = UIColor.darkGray
        colorTextLabel_Other = UIColor.red
        colorTextLabel_White = UIColor.white
        colorTextLabel_Black = UIColor.black
        //
        colorBackgroundButton_Light = UIColor.clear
        colorBackgroundButton_Normal = UIColor.white
        colorBackgroundButton_Dark = UIColor.black
        colorBackgroundButton_Other = UIColor.red
        //
        super.init()
    }
    
    func setStyle(_ style:AppStyle){
        
        //MARK: Para criar aplicações com set de estilos, implementar as variações abaixo:
        switch style {
        case .Default, .Light, .Dark, .Special:
            self.style = .Default
            //
            colorBackgroundScreen_Light = UIColor.lightGray
            colorBackgroundScreen_Normal = UIColor.gray
            colorBackgroundScreen_Dark = UIColor.darkGray
            colorBackgroundScreen_Other = UIColor.black
            //
            colorTextLabel_Light = UIColor.lightGray
            colorTextLabel_Normal = UIColor.gray
            colorTextLabel_Dark = UIColor.darkGray
            colorTextLabel_Other = UIColor.red
            colorTextLabel_White = UIColor.white
            colorTextLabel_Black = UIColor.black
            //
            colorBackgroundButton_Light = UIColor.clear
            colorBackgroundButton_Normal = UIColor.white
            colorBackgroundButton_Dark = UIColor.black
            colorBackgroundButton_Other = UIColor.red
            
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
