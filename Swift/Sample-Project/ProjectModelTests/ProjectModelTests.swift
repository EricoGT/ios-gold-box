//
//  ProjectModelTests.swift
//  ProjectModelTests
//
//  Created by Erico Gimenes Teixeira on 15/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import XCTest

class ProjectModelTests: XCTestCase {

    //MARK: - Properties:
    
    //var animation:UIImage?
    
    //MARK: - Class Methods
    
    override class func setUp() {
        // The setUp() class method is called exactly once for a test case, before its first test method is called. Override this method to customize the initial state for all tests in the test case.
        
    }
    
    override class func tearDown() {
        // The tearDown() class method is called exactly once for a test case, after its final test method completes. Override this method to perform any cleanup after all test methods have ended.
        
    }
    
    //MARK: - Instance Methods
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //animation = UIImage.init(named: "animation.gif")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Tests
    
    func testAnimatedImageWithAnimatedGIF_URL() {
        
        if let animation = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!) {
            if let gif = animation.images {
                if gif.count == 0 {
                    XCTAssert(false)
                }
            }
        }
    }
    
    func testAnimatedImageWithAnimatedGIF_Data() {
        
        do {
            if let animation = UIImage.animatedImageWithAnimatedGIF(data: try Data.init(contentsOf: Bundle.main.url(forResource: "animation", withExtension: "gif")!)) {
                if let gif = animation.images {
                    if gif.count == 0 {
                        XCTAssert(false)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
            XCTAssert(false)
        }
    }
    
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
