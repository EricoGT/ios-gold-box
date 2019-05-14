//
//  UIColor+PalleteTests.m
//  WalmartTests
//
//  Created by Murilo Alves Alborghette on 11/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+Pallete.h"

@interface UIColor_PalleteTests : XCTestCase

@end

@implementation UIColor_PalleteTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testColorWithWMBColorOption {
    
    UIColor *colorOptionLightBlue = [UIColor colorWithWMBColorOption:WMBColorOptionLightBlue];
    UIColor *colorOptionDarkBlue = [UIColor colorWithWMBColorOption:WMBColorOptionDarkBlue];
    UIColor *colorOptionFacebookBlue = [UIColor colorWithWMBColorOption:WMBColorOptionFacebookBlue];
    UIColor *colorOptionFacebookDarkBlue = [UIColor colorWithWMBColorOption:WMBColorOptionFacebookDarkBlue];
    UIColor *colorOptionDarkGray = [UIColor colorWithWMBColorOption:WMBColorOptionDarkGray];
    
    XCTAssertTrue([colorOptionLightBlue isEqual:RGBA(33.0f, 150.0f, 243.0f, 1.0f)]);
    XCTAssertTrue([colorOptionDarkBlue isEqual:RGBA(26.0f, 117.0f, 207.0f, 1.0f)]);
    XCTAssertTrue([colorOptionFacebookBlue isEqual:RGBA(59.0f, 89.0f, 152.0f, 1.0f)]);
    XCTAssertTrue([colorOptionFacebookDarkBlue isEqual:RGBA(47.0f, 73.0f, 127.0f, 1.0f)]);
    XCTAssertTrue([colorOptionDarkGray isEqual:RGBA(102.0f, 102.0f, 102.0f, 1.0f)]);
}

@end
