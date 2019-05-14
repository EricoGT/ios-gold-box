//
//  WBRNavigationBarButtonItemFactoryTests.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRNavigationBarButtonItemFactory.h"

@interface WBRNavigationBarButtonItemFactoryTests : XCTestCase

@end

@implementation WBRNavigationBarButtonItemFactoryTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateBarButtonItem {
    
    NSString *stringName = @"imgCartAddressNavbar";
    CGRect frameRect = CGRectMake(0, 0, 62, 44);
    
    UIBarButtonItem *barButtonItem = [WBRNavigationBarButtonItemFactory createBarButtonItemWithImageString:stringName andFrameRect:frameRect];
    
    XCTAssertNotNil(barButtonItem);
    XCTAssertTrue(CGRectEqualToRect(barButtonItem.customView.layer.frame, frameRect));
    XCTAssertEqualObjects(((UIButton *)barButtonItem.customView).imageView.image, [UIImage imageNamed:stringName]);
}

@end
