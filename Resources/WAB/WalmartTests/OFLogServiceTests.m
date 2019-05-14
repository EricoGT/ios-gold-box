//
//  OFLogServiceTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/4/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OFLogService.h"

@interface OFLogServiceTests : XCTestCase {
    
    @private
    OFLogService *ls;
}

@end

@implementation OFLogServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    ls = [[OFLogService alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    ls = nil;
}
- (void) testKeysJsonToLogService {
    
    [ls sendLogsWithErrorEvent:@"test" andRequestUrl:@"test" andRequestData:@"test" andResponseCode:@"test" andResponseData:@"test" andUserMessage:@"test" andScreen:@"test" andFragment:@"test"];
    
    NSDictionary *dictTest = ls.dictLog;
    NSArray *arrTestKeys = [dictTest allKeys];
    NSLog(@"dictTest arrayKeys: %@", arrTestKeys);
    
    NSArray *correctArrayLogs = @[@"deviceId",@"date",@"errorEvent",@"requestUrl",@"requestData",@"responseCode",@"responseData",@"userMessage",@"system",@"version",@"email",@"screen",@"fragment"];
    
    arrTestKeys = [arrTestKeys sortedArrayUsingSelector:@selector(compare:)];
    correctArrayLogs = [correctArrayLogs sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL isCorrect = NO;
    
    if ([arrTestKeys isEqualToArray:correctArrayLogs]) {
        isCorrect = YES;
    }
    
    XCTAssertTrue(isCorrect, @"Invalid keys NSDictionary to Log");
}

@end
