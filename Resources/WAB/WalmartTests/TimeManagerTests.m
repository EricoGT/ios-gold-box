//
//  TimeManagerTests.m
//  WalmartTests
//
//  Created by Guilherme Nunes Ferreira on 10/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimeManager.h"

@interface TimeManager()

+ (NSDate *)serverResponseDateStringToDate:(NSString *)dateString;

@end

@interface TimeManagerTests : XCTestCase

@end

@implementation TimeManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidateUTMs {
    
    NSDate *currentDate = [NSDate date];
    NSDate *invalidDate = [TimeManager invalidateUTMDate:currentDate];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:invalidDate];
    XCTAssertEqual(timeInterval, EXPIRE_SECONDS_UTMS);
}

- (void)testUTMsStillValid {
    
    NSDate *currentDate = [NSDate date];
    NSDate *invalidDate = [TimeManager invalidateUTMDate:currentDate];
    [WMBSession updateServerDateWithDate:currentDate];
    
    BOOL utmStillValid = [TimeManager UTMDateStillValid:currentDate];
    XCTAssertTrue(utmStillValid);
    
    BOOL utmStillValidFailure = [TimeManager UTMDateStillValid:invalidDate];
    XCTAssertFalse(utmStillValidFailure);
}

- (void)testServerResponseDateStringToString {
    
    NSString *date = @"Mon, 06 Nov 2017 17:45:56 GMT";
    NSDate *convertedDate = [TimeManager serverResponseDateStringToDate:date];
    XCTAssertTrue(YES);
}

@end
