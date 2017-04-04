//
//  InternetHelper.swift
//  Project-Swift
//
//  Created by Erico GT on 04/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

class InternetHelper: NSObject {
    
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
    override init(){
        super.init()
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    func post(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Dictionary<String, Any>?, _ statusCode:Int, _ error:NSError?) -> ()){
        
        //endpoint:
        guard let url = URL(string: toURL) else {
            
            completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            return
        }
        
        //request:
        var urlRequest = URLRequest(url: url)
        
        //headers:
        urlRequest.allHTTPHeaderFields = self.createDefaultHeader()
        
        //body:
        if let body = httpBodyData{
            do{
                try urlRequest.httpBody = JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            }catch{
                completionHandler(nil, 0, NSError.init(domain: "Error: JSONSerialization", code: 0, userInfo: ["message": error.localizedDescription]))
                return
            }
        }
        
        //method:
        urlRequest.httpMethod = "POST"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        let session = URLSession(configuration: config)

        //call:
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            var statusCodeResult:Int = 0
            
            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
                statusCodeResult = urlR.statusCode
            }
            
            guard error == nil else {
                
                completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                return
            }
            
            guard let responseData = data else {
                
                completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                return
            }
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else{
                    
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    return
                }
                
                //Success:
                completionHandler(jsonResult, statusCodeResult, nil)
                
                print("POST result: %@", jsonResult)
                
            } catch  {
                completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                return
            }
        }
        
        task.resume()
    }
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func getDeviceInfo() ->  Dictionary<String, String>{
        
        var deviceDic:Dictionary<String, String> =  Dictionary.init()
        //
        deviceDic["name"] = ToolBox.deviceHelper_Name()
        deviceDic["model"] = String.init(format: "Apple - %@", arguments: [ToolBox.deviceHelper_Model()])
        deviceDic["system_version"] = ToolBox.deviceHelper_SystemVersion()
        deviceDic["system_language"] = ToolBox.deviceHelper_SystemLanguage()
        deviceDic["storage_capacity"] = ToolBox.deviceHelper_StorageCapacity()
        deviceDic["free_memory_space"] = ToolBox.deviceHelper_FreeMemorySpace()
        deviceDic["identifier_for_vendor"] = ToolBox.deviceHelper_IdentifierForVendor()
        deviceDic["app_version"] = ToolBox.applicationHelper_VersionBundle()
        //
        return deviceDic
    }
    
    private func createDefaultHeader() -> Dictionary<String, String>{
        
        var headerDic:Dictionary<String, String> = Dictionary.init()
        //
        let token:String? = UserDefaults.standard.value(forKey: "PLISTKEY_ACCESS_TOKEN") as! String?
        headerDic["token"] = ToolBox.isNil(object: token as AnyObject?) ? "" :  token!
        //
        headerDic["Content-Type"] = "application/json"
        headerDic["Accept"] = "application/json"
        headerDic["idiom"] = App.STR("LANGUAGE_APP")
        headerDic["device_info"] = ToolBox.converterHelper_StringJsonFromDictionary(dictionary: getDeviceInfo() as NSDictionary)
        //
        return headerDic
    }
}
