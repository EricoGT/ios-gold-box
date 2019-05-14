//
//  UTMIModelTests.m
//  Walmart
//
//  Created by Renan on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UTMIModel.h"

@interface UTMIModel ()

- (NSString *)cleanString:(NSString *)str;

@end

@interface UTMIModelTests : XCTestCase

@property (strong, nonatomic) UTMIModel *utmi;

@end

@implementation UTMIModelTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
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

- (void)testSetSectionCleaningOtherFields
{
    [_utmi setSection:@"teste" cleanOtherFields:YES];
    
    XCTAssertNil(_utmi.department);
    XCTAssertNil(_utmi.category);
    XCTAssertNil(_utmi.subcategory);
    XCTAssertNil(_utmi.module);
    XCTAssertNil(_utmi.modulePosition);
    XCTAssertNil(_utmi.internalPosition);
    XCTAssertNil(_utmi.moduleLabel);
    XCTAssertNil(_utmi.internalLabel);
}

- (void)testSetSectionWithoutCleaningOtherFields
{
    [_utmi setSection:@"teste" cleanOtherFields:NO];
    
    XCTAssertNotNil(_utmi.department);
    XCTAssertNotNil(_utmi.category);
    XCTAssertNotNil(_utmi.subcategory);
    XCTAssertNotNil(_utmi.module);
    XCTAssertNotNil(_utmi.modulePosition);
    XCTAssertNotNil(_utmi.internalPosition);
    XCTAssertNotNil(_utmi.moduleLabel);
    XCTAssertNotNil(_utmi.internalLabel);
}

- (void)testSetModule
{
    [_utmi setModule:@"teste"];
    XCTAssertNil(_utmi.modulePosition);
    XCTAssertNil(_utmi.internalPosition);
    XCTAssertNil(_utmi.moduleLabel);
    XCTAssertNil(_utmi.internalLabel);
}

- (void)testTypeFormatted
{
    _utmi.type = UTMITypeNav;
    XCTAssertEqualObjects(@"utminav", _utmi.typeFormatted);
    
    _utmi.type = UTMITypeBan;
    XCTAssertEqualObjects(@"utmiban", _utmi.typeFormatted);
    
    _utmi.type = 5;
    XCTAssertEqualObjects(@"utminav", _utmi.typeFormatted);
}

- (void)testCleanString
{
    NSString *str = @"";
    str = [_utmi cleanString:str];
    XCTAssertEqualObjects(str, @"vazio");
    
    str = @"teste|";
    str = [_utmi cleanString:str];
    XCTAssertEqualObjects(str, @"teste");
    
    str = @"|";
    str = [_utmi cleanString:str];
    XCTAssertEqualObjects(str, @"");
    
    str = @"áãàâ";
    str = [_utmi cleanString:str];
    XCTAssertEqualObjects(str, @"aaaa");
}

- (void)testDescription
{
    NSString *description = [NSString stringWithFormat:@"iOS|%@|%@|%@|%@|%@|%@|%@|%@|%@",
                             [_utmi cleanString:_utmi.section],
                             [_utmi cleanString:_utmi.department],
                             [_utmi cleanString:_utmi.category],
                             [_utmi cleanString:_utmi.subcategory],
                             [_utmi cleanString:_utmi.module],
                             [_utmi cleanString:_utmi.modulePosition],
                             [_utmi cleanString:_utmi.internalPosition],
                             [_utmi cleanString:_utmi.moduleLabel],
                             [_utmi cleanString:_utmi.internalLabel]];
    XCTAssertEqualObjects(_utmi.description, description);
}

@end
