//
//  NSString+CookiesTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Cookies.h"

@interface NSString_CookiesTests : XCTestCase

@end

@implementation NSString_CookiesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCookieValueForKey {
    
    NSString *cookieKey = @"cart";
    NSString *cookieValue = @"app:15uh554vp3ub2v6x8z7b53bp";
    NSString *cookie = [NSString stringWithFormat:@"%@=%@;Path=/;Expires=Sat, 21-Jun-2014 15:06:19 GMT;Max-Age=1296000", cookieKey, cookieValue];
    
    XCTAssertTrue([[cookie cookieValueForKey:cookieKey] isEqualToString:cookieValue]);
}

@end
