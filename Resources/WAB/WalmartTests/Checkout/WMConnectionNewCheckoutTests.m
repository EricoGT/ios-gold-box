//
//  WMConnectionNewCheckoutTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/20/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WMConnectionNewCheckout.h"
#import "OFUrls.h"

@interface WMConnectionNewCheckoutTests : XCTestCase {
    
    WMConnectionNewCheckout *nc;
}

@end

@implementation WMConnectionNewCheckoutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    nc = [[WMConnectionNewCheckout alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHTTPMethod {
    
    [nc getCartWithGet];
    
    NSLog(@"Request: %@", nc.requestTest.HTTPMethod);
    
    NSString *strHTTPMethodCorrect = @"GET";
    NSString *strHTTPMethod = [NSString stringWithFormat:@"%@", nc.requestTest.HTTPMethod];
    
    XCTAssertTrue([strHTTPMethodCorrect isEqualToString:strHTTPMethod], @"Method should be GET");
}

- (void)testDataHeaderWithToken {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *system = @"iOS";
    
    NSDictionary *dictForTest = @{@"tkCk":@"xxx",
                                  @"cart":@"yyy"
                                  };
    
    NSDictionary *dictExpected = @{@"token":@"xxx",
                                   @"cart":@"yyy",
                                   @"system":system,
                                   @"version":version
                                  };
    
    nc.dictAuthStatus = dictForTest;
    
    [nc getCartWithGet];
    
    NSLog(@"Header Request: %@", nc.requestTest.allHTTPHeaderFields);
    
    NSDictionary *dictHeaderToTest = nc.requestTest.allHTTPHeaderFields;
    
    NSLog(@"Header Request For Test: %@", dictForTest);
    NSLog(@"Header Request To  Test: %@", dictHeaderToTest);
    
    XCTAssertTrue([dictExpected isEqualToDictionary:dictHeaderToTest], @"Header wrong!");
}

- (void)testDataHeaderWithoutToken {
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *system = @"iOS";
    
    NSDictionary *dictForTest = @{@"tkCk":@"",
                                  @"cart":@"yyy"
                                  };
    
    NSDictionary *dictExpected = @{@"cart":@"yyy",
                                   @"system":system,
                                   @"version":version
                                   };
    
    nc.dictAuthStatus = dictForTest;
    
    [nc getCartWithGet];
    
    NSLog(@"Header Request: %@", nc.requestTest.allHTTPHeaderFields);
    
    NSDictionary *dictHeaderToTest = nc.requestTest.allHTTPHeaderFields;
    
    NSLog(@"Header Request For Test: %@", dictForTest);
    NSLog(@"Header Request To  Test: %@", dictHeaderToTest);
    
    XCTAssertTrue([dictExpected isEqualToDictionary:dictHeaderToTest], @"Header wrong!");
}

@end
