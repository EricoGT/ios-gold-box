//
//  Project_ObjectiveCUITests.m
//  Project-ObjectiveCUITests
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ViewController.h"

@interface Project_ObjectiveCUITests : XCTestCase

@end

@implementation Project_ObjectiveCUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [XCUIApplication new];
    [app launch];
    
    XCUIDevice *device = [XCUIDevice sharedDevice];
    [device setOrientation:UIDeviceOrientationPortrait];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPushButton
{
    XCUIApplication *app = [XCUIApplication new];
    
    if ([app.buttons[@"CodePushID"] waitForExistenceWithTimeout:3.0]){
        
        [app.buttons[@"CodePushID"] tap];
        
        if ([app.buttons[@"ReturnButtonID"] waitForExistenceWithTimeout:2.0]){
            
            [app.buttons[@"ReturnButtonID"] tap];
            
            if (![app.buttons[@"CodePushID"] waitForExistenceWithTimeout:2.0]){
                
                XCTAssert(@"...");
                
            }
        }
        
    }
}

- (void)testModalButton
{
    XCUIApplication *app = [XCUIApplication new];
    
    if ([app.buttons[@"CodeModalID"] waitForExistenceWithTimeout:3.0]){
        
        [app.buttons[@"CodeModalID"] tap];
        
        if ([app.buttons[@"ReturnButtonID"] waitForExistenceWithTimeout:2.0]){
            
            [app.buttons[@"ReturnButtonID"] tap];
            
            if (![app.buttons[@"CodeModalID"] waitForExistenceWithTimeout:2.0]){
                
                XCTAssert(@"...");
                
            }
        }
        
    }
}

- (void)testSeguePushButton
{
    XCUIApplication *app = [XCUIApplication new];
    
    if ([app.buttons[@"SeguePushID"] waitForExistenceWithTimeout:3.0]){
        
        [app.buttons[@"SeguePushID"] tap];
        
        if ([app.buttons[@"ReturnButtonID"] waitForExistenceWithTimeout:2.0]){
            
            [app.buttons[@"ReturnButtonID"] tap];
            
            if (![app.buttons[@"SeguePushID"] waitForExistenceWithTimeout:2.0]){
                
                XCTAssert(@"...");
                
            }
        }
        
    }
}

- (void)testSegueModalButton
{
    XCUIApplication *app = [XCUIApplication new];
    
    if ([app.buttons[@"SegueModalID"] waitForExistenceWithTimeout:3.0]){
        
        [app.buttons[@"SegueModalID"] tap];
        
        if ([app.buttons[@"ReturnButtonID"] waitForExistenceWithTimeout:2.0]){
            
            [app.buttons[@"ReturnButtonID"] tap];
            
            if (![app.buttons[@"SegueModalID"] waitForExistenceWithTimeout:2.0]){
                
                XCTAssert(@"...");
                
            }
        }
        
    }
}
@end
