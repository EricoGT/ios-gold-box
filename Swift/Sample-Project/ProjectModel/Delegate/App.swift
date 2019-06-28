//
//  App.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

class App{
    
    //UIApplication
    class final var Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    //ToolBox
    class final var Utils:ToolBox.Type {
        return ToolBox.self
    }
    
    //****************************************************************************************************
    
    //MARK: - Extra Functions
    
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
