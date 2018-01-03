//
//  VME_DataManager.swift
//  Project-Swift
//
//  Created by Erico GT on 03/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

enum VME_MessageType:Int {
    case Generic           = 0
    case Success           = 1
    case Error             = 2
}

enum VME_MessageOptionType:Int {
    case Normal            = 0
    case Cancel            = 1
    case Destructive       = 2
}

//***********************************************

class VME_DataManager:NSObject, VME_DataManagerDelegate{
    
    weak var viewController:VME_ViewControllerDelegate?
    
    func getData(_ parameterName:String) -> Any?{
        return nil
    }
    
    func setData(_ parameterName:String, _ parameterValue:Any){
        
    }
    
}

//***********************************************



//***********************************************

class VME_Message:NSObject
{
    var title:String?
    var message:String?
    var code:String?
    var type:VME_MessageType
    var otions:Array<VME_MessageOption>?
    var userInteration:Bool
    
    override init(){
        title = ""
        message = ""
        code = ""
        type = .Generic
        otions = Array.init()
        userInteration = true
    }
}

//***********************************************

class VME_MessageOption:NSObject
{
    var text:String
    var type:VME_MessageOptionType
    var action:(() -> Void)?

    init(_ text:String, _ type:VME_MessageOptionType, _ action:@escaping () -> Void){
        self.text = text
        self.type = type
        self.action = action
    }
    
    override init(){
        self.text = ""
        self.type = .Normal
        self.action = nil
        //
        super.init()
    }
    
}

//***********************************************

protocol VME_ViewControllerDelegate:NSObjectProtocol
{
    func processMessage(_ message:VME_Message)
}

protocol VME_DataManagerDelegate
{
    func getData(_ parameterName:String) -> Any?
    func setData(_ parameterName:String, _ parameterValue:Any)
}
