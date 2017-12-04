//
//  Project_SwiftTests.swift
//  Project-SwiftTests
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import XCTest

@testable import Project_Swift

class Project_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let str:String = "30871355850"
        let ok:Bool = ToolBox.Text.applyMask(toText: NSString.init(string: str), mask: NSString.init(string: "###.###.###-##")) == "308.713.558-50"
        XCTAssert(ok, "Error")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
