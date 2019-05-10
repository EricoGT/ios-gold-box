//
//  WishlistProductTests.m
//  Walmart
//
//  Created by Renan on 6/15/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WishlistProduct.h"
#import "NSString+HTML.h"

@interface WishlistProductTests : XCTestCase

@property (strong, nonatomic) WishlistProduct *product;

@property (strong, nonatomic) WishlistSellerOption *firstSeller;
@property (strong, nonatomic) WishlistSellerOption *secondSeller;

@end

@implementation WishlistProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.product = [WishlistProduct new];
    
    self.firstSeller = [WishlistSellerOption new];
    self.secondSeller = [WishlistSellerOption new];
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[_firstSeller, _secondSeller]];
}

- (void)testIsLowPrice {
    [_product setStatusPrice:@1];
    XCTAssertFalse(_product.isLowPrice);
    
    [_product setStatusPrice:@(-1)];
    XCTAssertTrue(_product.isLowPrice);
}

- (void)testIsOutStock {
    [_product setQuantity:1];
    XCTAssertFalse(_product.isOutOfStock);
    
    [_product setQuantity:10];
    XCTAssertFalse(_product.isOutOfStock);
    
    [_product setQuantity:0];
    XCTAssertTrue(_product.isOutOfStock);
    
    [_product setQuantity:-1];
    XCTAssertTrue(_product.isOutOfStock);
}

- (void)testDefaultSellerOption {
    XCTAssertEqual(_firstSeller, _product.defaultSellerOption);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[_secondSeller, _firstSeller]];
    XCTAssertEqual(_secondSeller, _product.defaultSellerOption);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[_firstSeller]];
    XCTAssertEqual(_firstSeller, _product.defaultSellerOption);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[]];
    XCTAssertNil(_product.defaultSellerOption);
    
    [_product setSellerOptions:nil];
    XCTAssertNil(_product.defaultSellerOption);
}

- (void)testHasExtendedWarranty {
    _product.defaultSellerOption.hasExtendedWarranty = @YES;
    XCTAssertTrue(_product.hasExtendedWarranty);
    
    _product.defaultSellerOption.hasExtendedWarranty = @NO;
    XCTAssertFalse(_product.hasExtendedWarranty);
}

- (void)testDefaultName {
    _product.defaultSellerOption.name = @"Product Name Test";
    XCTAssertEqual([_product.defaultSellerOption.name kv_decodeHTMLCharacterEntities], _product.defaultName);
    
    _product.defaultSellerOption.name = nil;
    XCTAssertNil(_product.defaultName);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[]];
    XCTAssertNil(_product.defaultName);
    
    [_product setSellerOptions:nil];
    XCTAssertNil(_product.defaultName);
}

- (void)testDefaulSKU {
    _product.defaultSellerOption.sku = @123;
    XCTAssertEqual(_product.defaultSellerOption.sku, _product.defaultSKU);
    
    _product.defaultSellerOption.sku = nil;
    XCTAssertNil(_product.defaultSKU);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[]];
    XCTAssertNil(_product.defaultSKU);
    
    [_product setSellerOptions:nil];
    XCTAssertNil(_product.defaultSKU);
}

- (void)testFirstImageId {
    NSArray *imageIds = @[@"123", @"456"];
    _product.defaultSellerOption.imageIds = imageIds;
    XCTAssertEqualObjects(_product.firstImageId, imageIds.firstObject);
    
    _product.defaultSellerOption.imageIds = @[];
    XCTAssertNil(_product.firstImageId);
    
    _product.defaultSellerOption.imageIds = nil;
    XCTAssertNil(_product.firstImageId);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[]];
    XCTAssertNil(_product.firstImageId);
    
    [_product setSellerOptions:nil];
    XCTAssertNil(_product.firstImageId);
}

- (void)testDiscountPrice {
    _product.defaultSellerOption.discountPrice = @123;
    XCTAssertEqual(_product.defaultSellerOption.discountPrice, _product.discountPrice);
    
    _product.defaultSellerOption.discountPrice = nil;
    XCTAssertNil(_product.discountPrice);
    
    [_product setSellerOptions:(NSArray<WishlistSellerOption> *) @[]];
    XCTAssertNil(_product.discountPrice);
    
    [_product setSellerOptions:nil];
    XCTAssertNil(_product.discountPrice);
}

@end
