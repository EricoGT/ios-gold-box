//
//  ConnectionManager.swift
//  Project-Swift
//
//  Created by Erico GT on 3/30/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS
import Alamofire
import SwiftyJSON

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//@objc protocol ConnectionManagerDelegate:NSObjectProtocol
//{
//    @objc optional func didConnectWithSuccess(response:Dictionary<String, Any>)
//    @objc optional func didConnectWithFailure(error:NSError)
//    @objc optional func didConnectWithSuccess(responseData:Data)
//    @objc optional func didConnectWithSuccess(progress:Float)
//}

class ConnectionManager
{
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    
    var isConnectionReachable:Bool{
        return (Reachability()?.isReachable)!
    }
    
    var isConnectionReachableViaWiFi:Bool{
        return (Reachability()?.isReachableViaWiFi)!
    }
    
    //MARK: - • PRIVATE PROPERTIES
    
    
    //MARK: - • INITIALISERS
    init() {
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    func getDataFromServer(userID:Int, handler:@escaping (_ response:Dictionary<String, Any>?, _ statusCode:Int, _ error:NSError?) -> ()){
        
        //URL destino
        var urlRequest:String = "http://md5.jsontest.com/?text=<text>"
        urlRequest = urlRequest.replacingOccurrences(of: "<text>", with: "erico.gimenes")
        
        //Parameters
        let parameters: Parameters = [
            "x": 5,
            "y": 6
        ]
        
        //Headers
        let header: HTTPHeaders = self.createDefaultHeader()
        
        //Request
        Alamofire.request(urlRequest,
                       method: HTTPMethod.get,
                   parameters: parameters,
                     encoding: URLEncoding.default,
                      headers: header
            ).validate().responseJSON { (dResponse) in
                  
                switch dResponse.result {
                case .success:
                    
                    do{
                        let resultDic:Dictionary<String, Any> = try (JSONSerialization.jsonObject(with: dResponse.data!, options: []) as? [String: Any])!
                        handler(resultDic, (dResponse.response!.statusCode), nil)
                    }catch let error{
                        handler(nil, (dResponse.response!.statusCode), NSError(domain:String.init(format: "JSONSerialization Error: %@", arguments:[error.localizedDescription]), code:dResponse.response!.statusCode, userInfo:nil))
                    }
                    
                case .failure(let error):
                    
                    handler(nil, (dResponse.response?.statusCode)!, error as NSError)
                }
        }        
    }
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    private func getDeviceInfo() ->  Dictionary<String, String>{
        
        var deviceDic:Dictionary<String, String> =  Dictionary.init()
        //
        deviceDic["name"] = ToolBox.Device.name()
        deviceDic["model"] = String.init(format: "Apple - %@", arguments: [ToolBox.Device.model()])
        deviceDic["system_version"] = ToolBox.Device.systemVersion()
        deviceDic["system_language"] = ToolBox.Device.systemLanguage()
        deviceDic["storage_capacity"] = ToolBox.Device.storageCapacity()
        deviceDic["free_memory_space"] = ToolBox.Device.freeMemorySpace()
        deviceDic["identifier_for_vendor"] = ToolBox.Device.identifierForVendor()
        deviceDic["app_version"] = ToolBox.Application.versionBundle()
        //
        return deviceDic
    }
    
    private func createDefaultHeader() -> HTTPHeaders{
        
        let token:String? = UserDefaults.standard.value(forKey: "PLISTKEY_ACCESS_TOKEN") as! String?
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "idiom": NSLocalizedString("LANGUAGE_APP", comment: ""),
            "device_info": ToolBox.Converter.stringJsonFromDictionary(dictionary: getDeviceInfo() as NSDictionary, prettyPrinted: false),
            "token": ToolBox.isNil(token as AnyObject?) ? "" :  token!
        ]
        return header
    }
}




