//
//  ConnectionManager.swift
//  Project-Swift
//
//  Created by Erico GT on 3/30/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • ENUMS AND STRUCS
 
enum RequestMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias InternetRequestDataSource = URLSessionDataTask
//typealias AnotherTypeDataSource = <another_type>

class ConnectionManager : NSObject
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
    
    private var defaultTimeoutInterval:TimeInterval = 30
    
    //MARK: - • INITIALISERS
    override init() {
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS

    
    //MARK: - CONNECTION
    
    func connect(url:String, method:RequestMethod, body:Data?, handler:@escaping (_ response:Data?, _ statusCode:Int, _ error:Error?) -> ()) -> InternetRequestDataSource? {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig) //URLSession.shared
        let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        if let url = URL(string: escapedString) {
            
            var urlRequest = URLRequest(url: url)
            //method
            urlRequest.httpMethod = method.rawValue
            //configs
            urlRequest.timeoutInterval = defaultTimeoutInterval
            urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            //parameters
            urlRequest.httpBody = body
            //header
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("device", forHTTPHeaderField: self.getDeviceInfo().description)
            urlRequest.setValue("token", forHTTPHeaderField: "xxx")
            urlRequest.setValue("idiom", forHTTPHeaderField: "pt-BR")
            //request
            let task = session.dataTask(with: urlRequest) { (taskData, taskResponse, taskError) in
                //status code
                var code:Int = 0
                if let httpResponse = taskResponse as? HTTPURLResponse {
                    code = httpResponse.statusCode
                }
                //handler
                DispatchQueue.main.async {
                    handler(taskData, code, taskError)
                }
                
                #if DEBUG
                print("\n<<<<<<<<<<  INTERNET CONNECTION - START >>>>>>>>>>")
                print("\nFUNCTION: \(#function)")
                print("\nMETHOD: \(method.rawValue)")
                print("\nREQUEST: \(String(describing: urlRequest))")
                print("\nHEADERS: \(String(describing: urlRequest.allHTTPHeaderFields))")
                print("\nPARAMETERS: \(String(describing: body))")
                print("\nRESPONSE: \(String(describing: taskResponse))")
                print("\nDATA: \(String(describing: taskData))")
                print("\nERROR: \(String(describing: taskError))")
                print("\n<<<<<<<<<<  INTERNET CONNECTION - END >>>>>>>>>>")
                #endif
                
            }
            task.resume()
            return task
        }

        return nil
    }
    
    
    
    //MARK: - DOWNLOAD
    
    //MARK: - UPLOAD

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
    
}
