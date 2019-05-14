//
//  NSError+CustomErrorTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSError+CustomError.h"

@interface NSError_CustomErrorTests : XCTestCase

@end

@implementation NSError_CustomErrorTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testErrorWithCodeAndMessageAndFailureReason {
    
    NSInteger errorCode = 12345;
    NSString *errorMessage = @"error message";
    NSString *failureReasonMessage = @"failure reason message";
    
    NSError *error = [NSError errorWithCode:errorCode message:errorMessage failureReason:failureReasonMessage];
    XCTAssertTrue([error.localizedDescription isEqualToString:errorMessage]);
    XCTAssertTrue([error.localizedFailureReason isEqualToString:failureReasonMessage]);
    XCTAssertEqual(error.code, errorCode);
}

- (void)testErrorWithCodeAndMessage {
    
    NSInteger errorCode = 12345;
    NSString *errorMessage = @"error message";
    
    NSError *error = [NSError errorWithCode:errorCode message:errorMessage];
    XCTAssertTrue([error.localizedDescription isEqualToString:errorMessage]);
    XCTAssertEqual(error.code, errorCode);
    
}

- (void)testErrorWithMessage {
    
    NSString *errorMessage = @"error message";
    
    NSError *error = [NSError errorWithMessage:errorMessage];
    XCTAssertTrue([error.localizedDescription isEqualToString:errorMessage]);
}

@end
