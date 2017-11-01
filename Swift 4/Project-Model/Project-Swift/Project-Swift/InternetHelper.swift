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

//MARK: - • PROTOCOLS

@objc protocol InternetHelperDelegate: NSObjectProtocol {
    
    @objc optional func didFinishTaskWithSuccess(resultData:Dictionary<String, Any>)
    @objc optional func didFinishTaskWithError(error:NSError)
}

//MARK: - • CLASSES

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
    
    //MARK: - GET
    
    @discardableResult func get(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Any?, _ statusCode:Int, _ error:NSError?) -> ()) -> URLSessionDataTask? {
        
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
                
                print("POST result: %@", jsonResult)
                
            } catch  {
                
                OperationQueue.main.addOperation{
                    completionHandler(nil, statusCodeResult, NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                }
                return
            }
        }
        
        task.resume()
        
        return task
    }
    
    @discardableResult func get(toURL:String, httpBodyData:Dictionary<String, Any>?, delegate:InternetHelperDelegate?) -> URLSessionDataTask? {
        
        //endpoint:
        guard let url = URL(string: toURL) else {
            
            if (delegate != nil && delegate!.responds(to: Selector.init(("didFinishTaskWithError:")))){
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            }
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
                if (delegate != nil && delegate!.responds(to: Selector.init(("didFinishTaskWithError:")))){
                    delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: JSONSerialization", code: 0, userInfo: ["message": error.localizedDescription]))
                }
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
            
            //            var statusCodeResult:Int
            //
            //            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
            //                statusCodeResult = urlR.statusCode
            //            }
            
            guard error == nil else {
                
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                return
            }
            
            guard let responseData = data else {
                
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                return
            }
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else{
                    
                    delegate?.didFinishTaskWithError!(error: NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    return
                }
                print()
                //Success:
                delegate?.didFinishTaskWithSuccess!(resultData: jsonResult)
                
                print("POST result: %@", jsonResult)
                
            } catch  {
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                return
            }
        }
        
        task.resume()
        
        return task
    }
    
    //MARK: -
    
    @discardableResult func getCUSTOM(toURL:String, header:Dictionary<String, String>?, timeInterval:TimeInterval, completionHandler:@escaping (_ response:Dictionary<String, Any>?, _ statusCode:Int, _ error:NSError?) -> ()) -> URLSessionDataTask? {
        
        //endpoint:
        guard let url = URL(string: toURL) else {
            
            OperationQueue.main.addOperation{
                completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            }
            return nil
        }
        
        //request:
        var urlRequest = URLRequest(url: url)
        
        //headers:
        if let h = header {
            urlRequest.allHTTPHeaderFields = h
        }else{
            urlRequest.allHTTPHeaderFields = self.createDefaultHeader()
        }
        
        //method:
        urlRequest.httpMethod = "GET"
        
        //session configuration:
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeInterval
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
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else{
                    
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
        
        task.resume()
        
        return task
    }
    
    //MARK: - POST
    
    @discardableResult func post(toURL:String, httpBodyData:Dictionary<String, Any>?, completionHandler:@escaping (_ response:Dictionary<String, Any>?, _ statusCode:Int, _ error:NSError?) -> ()) -> URLSessionDataTask? {
        
        //endpoint:
        guard let url = URL(string: toURL) else {
            
            OperationQueue.main.addOperation{
                completionHandler(nil, 0, NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            }
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
                OperationQueue.main.addOperation{
                    completionHandler(nil, 0, NSError.init(domain: "Error: JSONSerialization", code: 0, userInfo: ["message": error.localizedDescription]))
                }
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
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else{
                    
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
        
        task.resume()
        
        return task
    }
    
    
    @discardableResult func post(toURL:String, httpBodyData:Dictionary<String, Any>?, delegate:InternetHelperDelegate?) -> URLSessionDataTask? {
        
        //endpoint:
        guard let url = URL(string: toURL) else {
            
            if (delegate != nil && delegate!.responds(to: Selector.init(("didFinishTaskWithError:")))){
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: Invalid URL", code: 0, userInfo: ["message": "Cannot create valid URL for 'toURL' parameter."]))
            }
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
                if (delegate != nil && delegate!.responds(to: Selector.init(("didFinishTaskWithError:")))){
                    delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: JSONSerialization", code: 0, userInfo: ["message": error.localizedDescription]))
                }
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
            
            //            var statusCodeResult:Int = 0
            //
            //            if let urlR:HTTPURLResponse = (urlResponse as? HTTPURLResponse){
            //                statusCodeResult = urlR.statusCode
            //            }
            
            guard error == nil else {
                
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: DataTask", code: 0, userInfo: ["message": error!.localizedDescription]))
                return
            }
            
            guard let responseData = data else {
                
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Error: No Data", code: 0, userInfo: ["message": "Did not receive data."]))
                return
            }
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:AnyObject] else{
                    
                    delegate?.didFinishTaskWithError!(error: NSError.init(domain: "JSONSerialization", code: 0, userInfo: ["message": "Error trying to convert data to JSON."]))
                    return
                }
                print()
                //Success:
                delegate?.didFinishTaskWithSuccess!(resultData: jsonResult)
                
                print("POST result: %@", jsonResult)
                
            } catch  {
                delegate?.didFinishTaskWithError!(error: NSError.init(domain: "Exception", code: 0, userInfo: ["message": error.localizedDescription]))
                return
            }
        }
        
        task.resume()
        
        return task
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
