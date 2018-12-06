//
//  DataSourceConnection.swift
//  Project-Swift
//
//  Created by Erico GT on 06/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

public enum InternetActiveConnectionType:Int {
    case unknown = 0
    case none = 1
    case wifi = 2
    case celldata = 3
}

class DataSourceConnection: NSObject {

    //properties
    public var activeConnectionType:InternetActiveConnectionType {
        let r:Reachability = Reachability()!
        switch r.currentReachabilityStatus {
        case .notReachable:
            return .none
        case .reachableViaWiFi:
            return .wifi
        case .reachableViaWWAN:
            return .celldata
        }
    }
    
    var isConnectionReachable:Bool{
        return (Reachability()?.isReachable)!
    }
    
    var isConnectionReachableViaWiFi:Bool{
        return (Reachability()?.isReachableViaWiFi)!
    }
    
    //MARK: • GET:
    @discardableResult func get(fromURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Any?, _ statusCode:Int, _ error:NSError?) -> ()) -> DataSourceRequest? {
        
        //endpoint:
        guard let url = URL(string: fromURL.replacingOccurrences(of: " ", with: "%20")) else {
            
            completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            return nil
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
                return nil
            }
        }
        
        //method:
        urlRequest.httpMethod = "GET"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        //config.requestCachePolicy = .useProtocolCachePolicy
        
        let session = URLSession(configuration: config)
        
        //call:
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            var statusCodeResult:Int = 0
            
            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
                statusCodeResult = urlR.statusCode
            }
            
            guard error == nil else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                }
                return
            }
            
            guard let responseData = data else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                }
                return
            }
            
            do {
                
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any? else{
                    
                    OperationQueue.main.addOperation{
                        completionHandler(nil, statusCodeResult, NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    }
                    return
                }
                
                //Success:
                OperationQueue.main.addOperation{
                    completionHandler(jsonResult, statusCodeResult, nil)
                }
                
                print("GET result: %@", jsonResult)
                
            } catch  {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                }
                return
            }
        }
        
        let dsr:DataSourceRequest = DataSourceRequest.newRequest(task)
        
        task.resume()
        
        return dsr
    }
    
    //MARK: • POST:
    @discardableResult func post(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Any?, _ statusCode:Int, _ error:NSError?) -> ()) -> DataSourceRequest? {
        
        //endpoint:
        guard let url = URL(string: toURL.replacingOccurrences(of: " ", with: "%20")) else {
            
            completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            return nil
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
                return nil
            }
        }
        
        //method:
        urlRequest.httpMethod = "POST"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        //config.requestCachePolicy = .useProtocolCachePolicy
        
        let session = URLSession(configuration: config)
        
        //call:
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            var statusCodeResult:Int = 0
            
            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
                statusCodeResult = urlR.statusCode
            }
            
            guard error == nil else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                }
                return
            }
            
            guard let responseData = data else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                }
                return
            }
            
            do {
                
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any? else{
                    
                    OperationQueue.main.addOperation{
                        completionHandler(nil, statusCodeResult, NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    }
                    return
                }
                
                //Success:
                OperationQueue.main.addOperation{
                    completionHandler(jsonResult, statusCodeResult, nil)
                }
                
                print("POST result: %@", jsonResult)
                
            } catch  {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                }
                return
            }
        }
        
        let dsr:DataSourceRequest = DataSourceRequest.newRequest(task)
        
        task.resume()
        
        return dsr
    }
    
    //MARK: • PUT:
    @discardableResult func put(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Any?, _ statusCode:Int, _ error:NSError?) -> ()) -> DataSourceRequest? {
        
        //endpoint:
        guard let url = URL(string: toURL.replacingOccurrences(of: " ", with: "%20")) else {
            
            completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            return nil
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
                return nil
            }
        }
        
        //method:
        urlRequest.httpMethod = "PUT"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        //config.requestCachePolicy = .useProtocolCachePolicy
        
        let session = URLSession(configuration: config)
        
        //call:
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            var statusCodeResult:Int = 0
            
            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
                statusCodeResult = urlR.statusCode
            }
            
            guard error == nil else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                }
                return
            }
            
            guard let responseData = data else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                }
                return
            }
            
            do {
                
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any? else{
                    
                    OperationQueue.main.addOperation{
                        completionHandler(nil, statusCodeResult, NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    }
                    return
                }
                
                //Success:
                OperationQueue.main.addOperation{
                    completionHandler(jsonResult, statusCodeResult, nil)
                }
                
                print("PUT result: %@", jsonResult)
                
            } catch  {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                }
                return
            }
        }
        
        let dsr:DataSourceRequest = DataSourceRequest.newRequest(task)
        
        task.resume()
        
        return dsr
    }
    
    //MARK: • PACTH:
    @discardableResult func patch(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Any?, _ statusCode:Int, _ error:NSError?) -> ()) -> DataSourceRequest? {
        
        //endpoint:
        guard let url = URL(string: toURL.replacingOccurrences(of: " ", with: "%20")) else {
            
            completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            return nil
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
                return nil
            }
        }
        
        //method:
        urlRequest.httpMethod = "PATCH"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        //config.requestCachePolicy = .useProtocolCachePolicy
        
        let session = URLSession(configuration: config)
        
        //call:
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            var statusCodeResult:Int = 0
            
            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
                statusCodeResult = urlR.statusCode
            }
            
            guard error == nil else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                }
                return
            }
            
            guard let responseData = data else {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                }
                return
            }
            
            do {
                
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any? else{
                    
                    OperationQueue.main.addOperation{
                        completionHandler(nil, statusCodeResult, NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    }
                    return
                }
                
                //Success:
                OperationQueue.main.addOperation{
                    completionHandler(jsonResult, statusCodeResult, nil)
                }
                
                print("PATCH result: %@", jsonResult)
                
            } catch  {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                }
                return
            }
        }
        
        let dsr:DataSourceRequest = DataSourceRequest.newRequest(task)
        
        task.resume()
    
        return dsr
    }
    
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
    
    private func createDefaultHeader() -> Dictionary<String, String>{
        
        var headerDic:Dictionary<String, String> = Dictionary.init()
        //
        let token:String? = UserDefaults.standard.value(forKey: "PLISTKEY_ACCESS_TOKEN") as! String?
        headerDic["token"] = ToolBox.isNil(token as AnyObject?) ? "" :  token!
        //
        headerDic["Content-Type"] = "application/json"
        headerDic["Accept"] = "application/json"
        headerDic["idiom"] = App.STR("LANGUAGE_APP")
        headerDic["device_info"] = ToolBox.Converter.stringJsonFromDictionary(dictionary: getDeviceInfo() as NSDictionary, prettyPrinted: false)
        //
        return headerDic
    }
    
}
