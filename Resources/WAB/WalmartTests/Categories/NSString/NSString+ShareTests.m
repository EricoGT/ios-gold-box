//
//  NSString+ShareTests.m
//  Walmart
//
//  Created by Renan on 6/13/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+Share.h"

@interface NSString_ShareTests : XCTestCase

@end

@implementation NSString_ShareTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testShareString {
    XCTAssertTrue([[@"”,shareString\"" shareString] isEqualToString:@"sharestring"]);
    XCTAssertTrue([[@"share String" shareString] isEqualToString:@"share-string"]);
    XCTAssertTrue([[@"'!@#$%¨&+,/-*()?:;={}][º´®`².–Ø½¼%«¨Ð„–°_`¡¯»¨ª." shareString] stringByReplacingOccurrencesOfString:@"-" withString:@""].length == 0);
}

@end
