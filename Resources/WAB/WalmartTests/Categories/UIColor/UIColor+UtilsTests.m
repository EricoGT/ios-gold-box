//
//  UIColor+UtilTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+Utils.h"

@interface UIColor_UtilsTests : XCTestCase

@end

@implementation UIColor_UtilsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testColorWithArray {
    
    NSArray *rgbaRedColorWithAlpha = @[@255.0, @0.0, @0.0, @0.5];
    UIColor *color = [UIColor colorWithArray:rgbaRedColorWithAlpha];
    UIColor *redColorWithAlpha = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    
    XCTAssertTrue([redColorWithAlpha isEqual:color]);
}

@end
