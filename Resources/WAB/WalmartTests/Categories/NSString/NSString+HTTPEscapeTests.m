//
//  NSString+HTTPEscapeTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/5/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+HTTPEscape.h"

@interface NSString_HTTPEscapeTests : XCTestCase

@end

@implementation NSString_HTTPEscapeTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEscapeFromBreakLine {
    XCTAssertTrue([[@"teste\nteste2" escapeFromBreakLine] isEqualToString:@"teste\\nteste2"]);
    XCTAssertTrue([[@"teste teste2" escapeFromBreakLine] isEqualToString:@"teste teste2"]);
}

@end
