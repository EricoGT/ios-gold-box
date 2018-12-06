//
//  DataSourceRequest.swift
//  Project-Swift
//
//  Created by Erico GT on 06/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

class DataSourceRequest: NSObject {
    
    public var sessionDataTask : URLSessionDataTask?
    
    override init() {
        sessionDataTask = nil
    }
    
    class func newRequest(_ task:URLSessionDataTask) -> DataSourceRequest{
        let dsr:DataSourceRequest = DataSourceRequest.init()
        dsr.sessionDataTask = task
        return dsr
    }
    
}
