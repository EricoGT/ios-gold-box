//
//  BaseDataSource.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 27/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import Alamofire
import UIKit

class ConnectionDataSource
{
    var isConnectionReachable:Bool{
        return (Reachability()?.isReachable)!
    }
    
    var isConnectionReachableViaWiFi:Bool{
        return (Reachability()?.isReachableViaWiFi)!
    }

    func connectInternet(url:String, method:HTTPMethod, parameters:Dictionary<String, Any>?, handler:@escaping (_ response:Data?, _ statusCode:Int, _ error:Error?) -> ()) -> DataRequest {

        //Headers
        let header: HTTPHeaders = self.createDefaultHeader()

        //Request
        let request = Alamofire.SessionManager.default.request(url,
                       method: method,
                   parameters: parameters,
                     encoding: URLEncoding.default,
                      headers: header
            ).validate().responseJSON { (dResponse) in

                var code = -1
                if let c = dResponse.response?.statusCode {
                    code = c
                }
                
                switch dResponse.result {
                    case .success:
                        if let data = dResponse.data {
                             handler(data, code, nil)
                        } else {
                            handler(nil, code, nil)
                        }

                    case .failure(let error):
                        handler(nil, (dResponse.response?.statusCode)!, error as NSError)
                }
        }
        
        return request
    }
    
    //MARK: - DOWNLOAD
    
    //TODO:
    
    //MARK: - UPLOAD
    
    //TODO:
    
    //MARK: - PRIVATE METHODS
    
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
}



