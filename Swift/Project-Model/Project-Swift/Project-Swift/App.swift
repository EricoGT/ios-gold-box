//
//  AppD.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

class App{
    
    //UIApplication
    class final var Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //Localizable
    class final func STR(_ string:String) -> String{
        return  NSLocalizedString(string, comment: "")
    }
    
    //ToolBox
    class final var Utils:ToolBox.Type {
        return ToolBox.self
    }
    
    //ConnectionManager
    class final var Connection:ConnectionManager{
        return ConnectionManager.init()
    }
    
    //Constants
    class final var Constants:ConstantsManager.Type{
        return ConstantsManager.self
    }
    
    //Sounds
    class final var Sounds:SoundManager{
        return SoundManager.init()
    }
    
    //Style
    class final var Style:LayoutStyleManager{
        return LayoutStyleManager.init()
    }
    
    //Location
    
    //DataBase
    
    //EXTRA ========================================================================
    
    //Random Numbers
    class final func RandInt(_ start:Int, _ end:Int) -> Int{
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    class final func Rand() -> Float{
        return Float(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    class func printAvailableFonts(){
        
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}
