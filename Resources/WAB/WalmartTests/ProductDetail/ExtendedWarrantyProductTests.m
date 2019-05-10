//
//  ExtendedWarrantyProductTests.m
//  Walmart
//
//  Created by Renan on 6/15/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ExtendedWarrantyProduct.h"

@interface ExtendedWarrantyProductTests : XCTestCase

@property (strong, nonatomic) ExtendedWarrantyProduct *extendedWarrantyProduct;

@end

@implementation ExtendedWarrantyProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.extendedWarrantyProduct = [ExtendedWarrantyProduct new];
}

//- (void)DISABLED_testSetExtendedWarranties {
//    [_extendedWarrantyProduct setExtendedWarranties:((NSArray<ExtendedWarranty> *) @[[ExtendedWarranty new], [ExtendedWarranty new]])];
//    
//    ExtendedWarranty *firstExtendedWarranty = _extendedWarrantyProduct.extendedWarranties.firstObject;
//    XCTAssertTrue(firstExtendedWarranty.isActive);
//    XCTAssertEqualObjects(firstExtendedWarranty.months, @0);
//    XCTAssertEqualObjects(firstExtendedWarranty.instalment, @0);
//    XCTAssertEqualObjects(firstExtendedWarranty.extendedWarrantyId, @0);
//    XCTAssertEqualObjects(firstExtendedWarranty.type, @"GARANTIA_ESTENDIDA");
//    XCTAssertEqualObjects(firstExtendedWarranty.price, @0);
//    XCTAssertEqualObjects(firstExtendedWarranty.sku, @0);
//    XCTAssertEqualObjects(firstExtendedWarranty.warrantyType, @"");
//    XCTAssertEqualObjects(firstExtendedWarranty.name, @"");
//    XCTAssertEqualObjects(firstExtendedWarranty.instalmentValue, @0);
//}

@end
