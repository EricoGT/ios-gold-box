//
//  ShowcaseProductTests.m
//  Walmart
//
//  Created by Renan on 6/15/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ShowcaseProductModel.h"

@interface ShowcaseProductTests : XCTestCase

@property (strong, nonatomic) ShowcaseProductModel *product;

@end

@implementation ShowcaseProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.product = [ShowcaseProductModel new];
}

- (void)testSetWishlist {
    [_product setIsRefreshingWishlistStatus:YES];
    
    [_product setWishlist:YES];
    XCTAssertFalse(_product.isRefreshingWishlistStatus);
    
    [_product setWishlist:NO];
    XCTAssertFalse(_product.isRefreshingWishlistStatus);
}

- (void)testIsEqual {
    [_product setSkuId:@2];
    
    ShowcaseProductModel *otherProduct = [ShowcaseProductModel new];
    [otherProduct setSkuId:@2];
    XCTAssertEqualObjects(_product, otherProduct);
    
    [otherProduct setSkuId:@0];
    XCTAssertNotEqualObjects(_product, otherProduct);
}

- (void)testFavoriteSKU {
    NSNumber *favoriteSKU = @123;
    [_product setFavoriteSKU:favoriteSKU];
    XCTAssertEqual(_product.favoriteSKU, favoriteSKU);
    
    [_product setFavoriteSKU:nil];
    [_product setSkuId:@2];
    XCTAssertEqualObjects(@2, _product.favoriteSKU);
}

@end
