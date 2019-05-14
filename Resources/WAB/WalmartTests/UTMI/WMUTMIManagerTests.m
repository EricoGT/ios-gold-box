//
//  WMUTMIManagerTests.m
//  Walmart
//
//  Created by Renan on 10/28/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WMUTMIManagerTests : XCTestCase

@property (strong, nonatomic) UTMIModel *utmi;

@end

@implementation WMUTMIManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.utmi = [UTMIModel new];
    _utmi.department = @"teste";
    _utmi.category = @"teste";
    _utmi.subcategory = @"teste";
    _utmi.module = @"teste";
    _utmi.modulePosition = @"teste";
    _utmi.internalPosition = @"teste";
    _utmi.moduleLabel = @"teste";
    _utmi.internalLabel = @"teste";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStoreAndGetUTMI
{
    [WMUTMIManager storeUTMI:_utmi];
    UTMIModel *storedUTMI = [WMUTMIManager UTMI];
    
    XCTAssertEqualObjects(_utmi.section, storedUTMI.section);
    XCTAssertEqualObjects(_utmi.department, storedUTMI.department);
    XCTAssertEqualObjects(_utmi.category, storedUTMI.category);
    XCTAssertEqualObjects(_utmi.subcategory, storedUTMI.subcategory);
    XCTAssertEqualObjects(_utmi.module, storedUTMI.module);
    XCTAssertEqualObjects(_utmi.modulePosition, storedUTMI.modulePosition);
    XCTAssertEqualObjects(_utmi.internalPosition, storedUTMI.internalPosition);
    XCTAssertEqualObjects(_utmi.moduleLabel, storedUTMI.moduleLabel);
    XCTAssertEqualObjects(_utmi.internalLabel, storedUTMI.internalLabel);
}

- (void)testClean
{
    [WMUTMIManager storeUTMI:_utmi];
    [WMUTMIManager clean];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    XCTAssertNil([defaults objectForKey:kUTMIStored]);
}

@end
