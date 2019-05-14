//
//  WMTokenCartId.m
//  Walmart
//
//  Created by Marcelo Santos on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "WMTokens.h"

@interface WMTokenCartId : XCTestCase {
    
@private
    WMTokens *tok;
    NSString *wordToTest;
}


@end

@implementation WMTokenCartId

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    tok = [[WMTokens alloc] init];
    wordToTest = @"CART TESTE";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    tok = nil;
    [tok deleteCartId:wordToTest];
}

- (void) testAddTokenCheckout {
    
    NSString *strError = [NSString stringWithFormat:@"CartID %@ Fail to persist", wordToTest];
    
    XCTAssertTrue([tok addCartId:wordToTest], @"%@", strError);
}

- (void) testGetTokenCheckout {
    
    [tok addCartId:wordToTest];
    
    NSString *strError = [NSString stringWithFormat:@"Value should be %@", wordToTest];
    
    XCTAssertEqualObjects([tok getCartId], wordToTest, @"%@", strError);
}

- (void) testDeleteTokenCheckout {
    
    [tok addCartId:wordToTest];
    [tok deleteCartId:wordToTest];
    
    NSString *strError = [NSString stringWithFormat:@"CartID %@ not removed", wordToTest];
    
    XCTAssertEqualObjects([tok getCartId], @"", @"%@", strError);
}

@end
