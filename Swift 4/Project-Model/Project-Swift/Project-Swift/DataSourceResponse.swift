//
//  DataSourceResponse.swift
//  Etna
//
//  Created by Erico GT on 25/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

protocol DataSourceResponseProtocol:NSObjectProtocol {
    func errorMessage(_ forType:DataSourceResponseErrorType, _ identifier:String?) -> String
}

public enum DataSourceResponseStatus:Int {
    case none = 0
    case success = 1
    case error = 2
    case processing = 3
    case cancelled = 4
}

public enum DataSourceResponseErrorType:Int {
    case none = 0
    case no_connection = 1
    case connection_error = 2
    case invalid_data = 3
    case internal_exception = 4
    case generic = 5
}

class DataSourceResponse: NSObject {
    
    var status:DataSourceResponseStatus
    var code: Int
    var message:String
    var error:DataSourceResponseErrorType
    
    override init() {
        status = .none
        code = 0
        message = ""
        error = .none
    }
    
    class func new(_ status:DataSourceResponseStatus, _ code:Int, _ message:String, _ error:DataSourceResponseErrorType) -> DataSourceResponse{
        
        let dsr:DataSourceResponse = DataSourceResponse.init()
        //
        dsr.status = status
        dsr.code = code
        dsr.message = message
        dsr.error = error
        //
        return dsr
    }
    
}

