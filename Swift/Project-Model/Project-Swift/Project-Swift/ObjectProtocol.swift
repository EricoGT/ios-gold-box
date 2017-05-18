//
//  ObjectProtocol.swift
//  Project-Swift
//
//  Created by Erico GT on 15/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(other:Dictionary?) {
        if let oDic = other {
            for (key,value) in oDic {
                self.updateValue(value, forKey:key)
            }
        }
    }
}

protocol ObjectProtocol{
    associatedtype T
    
    static func new(_ objectDictionary:Dictionary<String, Any>?, _ typeD:String?) -> T?
    func copy() -> T
    func isEqual(_ objectToCompare:T?) -> Bool
    func dictionary(_ typeD:String?) -> Dictionary<String, Any>
}
