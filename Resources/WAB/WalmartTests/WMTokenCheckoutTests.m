//
//  WMTokenCheckoutTests.m
//  Walmart
//
//  Created by Marcelo Santos on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WMTokens.h"

@interface WMTokenCheckoutTests : XCTestCase {
    
@private
    WMTokens *tok;
    NSString *wordToTest;
}

@end

@implementation WMTokenCheckoutTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    tok = [[WMTokens alloc] init];
    wordToTest = @"CHECKOUT TESTE";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    tok = nil;
    [tok deleteTokenCheckout:wordToTest];
}

- (void) testAddTokenCheckout {
    
    NSString *strError = [NSString stringWithFormat:@"Token %@ Fail to persist", wordToTest];
    
    XCTAssertTrue([tok addTokenCheckout:wordToTest], @"%@", strError);
}

- (void) testGetTokenCheckout {
    
    [tok addTokenCheckout:wordToTest];
    
    NSString *strError = [NSString stringWithFormat:@"Value should be %@", wordToTest];
    
    XCTAssertEqualObjects([tok getTokenCheckout], wordToTest, @"%@", strError);
}

- (void) testDeleteTokenCheckout {
    
    [tok addTokenCheckout:wordToTest];
    [tok deleteTokenCheckout:wordToTest];
    
    NSString *strError = [NSString stringWithFormat:@"Token %@ not removed", wordToTest];
    
    XCTAssertEqualObjects([tok getTokenCheckout], @"", @"%@", strError);
}

@end
