//
//  TokenTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/31/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WMTokens.h"

@interface TokenTests : XCTestCase {
    
    @private
    WMTokens *tok;
}

@end

@implementation TokenTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    tok = [[WMTokens alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    tok = nil;
}

//- (void)testTokenAddGetDeleteOAUTH {
//    
//    XCTAssertTrue([tok addTokenOAuth:@"OAUTH"], @"Token OAUTH Fail to persist");
//    XCTAssertEqualObjects([tok getTokenOAuth], @"OAUTH", @"Value should be OAUTH");
//    XCTAssertTrue([tok deleteTokenOAuth:@"OAUTH"], @"Token OAUTH not removed");
//}
//
//- (void)testTokenAddGetDeleteCheckout {
//    
//    XCTAssertTrue([tok addTokenCheckout:@""], @"Token empty Fail to persist");
//    XCTAssertEqualObjects([tok getTokenCheckout], @"", @"Value should be empty");
//    XCTAssertTrue([tok deleteTokenCheckout:@"CHECK"], @"Token CHECK not removed");
//}
//
//- (void)testCartIdAddGetDelete {
//    
//    XCTAssertTrue([tok addCartId:@"CART"], @"Token CART Fail to persist");
//    XCTAssertEqualObjects([tok getCartId], @"CART", @"Value should be CART");
//    XCTAssertTrue([tok deleteCartId:@"CART"], @"Token CART not removed");
//}

@end
