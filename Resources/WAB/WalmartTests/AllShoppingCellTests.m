//
//  AllShoppingCellTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/14/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AllShoppingCell.h"
#import "DepartmentMenuItem.h"
#import "AllShoppingViewController.h"
#import "OFUrls.h"

@interface AllShoppingCellTests : XCTestCase {
    
    AllShoppingCell *as;
    DepartmentMenuItem *dm;
    AllShoppingViewController *sh;
}

@end

@implementation AllShoppingCellTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    as = [[AllShoppingCell alloc] init];
    dm = [[DepartmentMenuItem alloc] init];
    sh = [[AllShoppingViewController alloc] init];
    [sh view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    as = nil;
    dm = nil;
    [super tearDown];
}

- (void) testAllShoppingCellSetupCellWithDepartmentMenuItem {
    
    dm.name = @"Eletrônicos";
    dm.image = @"https://www.walmart.com";
    
    [as setupCellWithDepartmentMenuItem:dm];
    
    XCTAssertTrue([as.strName isEqualToString:@"Eletrônicos"], @"The value should be: 'Eletrônicos'");
    XCTAssertTrue([as.strImage isEqualToString:@"https://www.walmart.com"], @"The value should be 'https://www.walmart.com'");
}

- (void) testDepartmentsMenuItemObjects {
    
    dm.departmentId = [NSNumber numberWithInt:123];
    dm.url = @"https://wm.com";
    dm.useHub = [NSNumber numberWithBool:YES];
    dm.imageSelected = @"image1.png";
    dm.imageName = @"image1";
    dm.isAllDepartments = [NSNumber numberWithBool:NO];
    
    XCTAssertEqualObjects(dm.departmentId, @123, @"Department ID is different!");
    XCTAssertEqualObjects(dm.url, @"https://wm.com", @"Url is different!");
    XCTAssertEqualObjects(dm.useHub, @YES, @"useHub is different!");
    XCTAssertEqualObjects(dm.imageSelected, @"image1.png", @"imageSelected is different!");
    XCTAssertEqualObjects(dm.imageName, @"image1", @"imageName is different!");
    XCTAssertEqualObjects(dm.isAllDepartments, @NO, @"isAllDepartments is different!");
}

@end
