//
//  App.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

enum MyEnum: Int {
    case item0 = 0
    case item1 = 1
    case item2 = 2
    case item3 = 3
    
    static func build(_ rawValue: Int) -> MyEnum {
        return MyEnum(rawValue: rawValue) ?? .item0
    }
}

class App{
    
    //UIApplication
    class final var Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    //ToolBox
    class final var Utils:ToolBox.Type {
        return ToolBox.self
    }
    
    //String
    
    //Simples texto localizado
    static func STR(_ keyName: String) -> String {
        return NSLocalizedString(keyName, comment: "")
    }
    
    //Texto localizado de uma determinada tabela
    static func STR(_ keyName: String, _ tableName: String) -> String {
        return NSLocalizedString(keyName, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
    
    //Enum de uma tabela (hash table)
    static func STR_MYTABLE(_ keyName: String) -> MyEnum {
        let text = NSLocalizedString(keyName, tableName: "MyTable", bundle: Bundle.main, value: "", comment: "")
        if let number = Int.init(text) {
            return MyEnum.build(number)
        }
        return .item0
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
