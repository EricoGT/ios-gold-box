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

enum VME_EventType:Int {
    case Report               = 0
    case BackgroundAction     = 1
    case Interruption         = 2
    case Navigation           = 3
    case Exception            = 4
}

enum VME_ViewCoordinatorState:Int {
    case Load                   = 0
    case WillAppear             = 1
    case DidAppear              = 2
    case WillDisappear          = 3
    case DidDisappear           = 4
    case Operational            = 5
    case EnterBackground        = 6
    case EnterForeground        = 7
}

//***********************************************

protocol VME_DataManager:NSObjectProtocol{
    
    //Propertie getter
    weak var viewController:(UIViewController&VME_ViewCoordinatorDelegate)? { get }
    
    //Coordinator State Change
    func reportStateChange(state: VME_ViewCoordinatorState)
    
    //Data Provider
    func getData(parameterID:String, handler:@escaping (_ data:Any?, _ message:VME_Message) -> ())
    
    //Data Processing
    func setData(parameterID:String, parameterValue:Any, handler:@escaping (_ message:VME_Message) -> ())
}

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
        userInteration = false
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

class VME_Event:NSObject
{
    var code:String
    weak var sender:UIView?
    var type:VME_EventType
    var message:VME_Message?
    var data:Any?
    var action:(() -> Void)?
    
    override init(){
        self.code = ""
        self.sender = nil
        self.type = .Report
        self.message = nil
        self.action = nil
        self.data = nil
        //
        super.init()
    }
}

//***********************************************

protocol VME_ViewCoordinatorDelegate:NSObjectProtocol
{
    var dataManagerDelegate:VME_DataManager{ get }
    //
    func processMessage(_ message:VME_Message)
    func processEvent(_ event:VME_Event)
    func currentState() -> VME_ViewCoordinatorState
}
