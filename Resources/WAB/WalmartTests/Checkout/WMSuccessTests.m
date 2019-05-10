//
//  WMSuccessTests.m
//  Walmart
//
//  Created by Marcelo Santos on 6/9/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WMSuccessViewController.h"

@interface WMSuccessTests : XCTestCase

@property (nonatomic) WMSuccessViewController *wms;

@end

@interface WMSuccessViewController (Test)

@property BOOL mustBeVerified;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, assign) UIUserNotificationType typeNotif;

- (void) verifyPush;
@end

@implementation WMSuccessTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _wms = [[WMSuccessViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVerifyPush {
    
    _wms.typeNotif = UIUserNotificationTypeNone;
    XCTAssertTrue(_wms.typeNotif == 0, @"Notification should be 0");
    _wms.typeNotif = UIUserNotificationTypeAlert;
    XCTAssertTrue(_wms.typeNotif > 0, @"Notification should be 0");
    
    _wms.mustBeVerified = YES;
    XCTAssertTrue(_wms.mustBeVerified == 1, @"Notification should be TRUE");
    _wms.mustBeVerified = NO;
    XCTAssertTrue(_wms.mustBeVerified == 0, @"Notification should be FALSE");
}

@end
