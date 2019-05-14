//
//  WishlistInteractorTests.m
//  Walmart
//
//  Created by Renan Cargnin on 3/15/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WishlistInteractor.h"

@interface WishlistInteractorTests : XCTestCase

@property (strong, nonatomic) NSArray *wishlistSKUs;
@property (strong, nonatomic) NSArray *productsSKUs;

@end

@implementation WishlistInteractorTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAllFavorited {
    self.wishlistSKUs = @[@1, @2, @3, @4, @5];
    self.productsSKUs = @[@1, @2, @3, @4, @5];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    for (NSNumber *isFavorite in correspondanceArray) {
        XCTAssertTrue(isFavorite.boolValue);
    }
}

- (void)testAllUnfavorited {
    self.wishlistSKUs = @[@1, @2, @3, @4, @5];
    self.productsSKUs = @[@6, @7, @8, @9, @10];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    for (NSNumber *isFavorite in correspondanceArray) {
        XCTAssertFalse(isFavorite.boolValue);
    }
}

- (void)testNoFavorites {
    self.wishlistSKUs = @[];
    self.productsSKUs = @[@6, @7, @8, @9, @10];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    XCTAssertTrue(correspondanceArray.count == 0);
}

- (void)testNoProducts {
    self.wishlistSKUs = @[@1, @2, @3, @4, @5];
    self.productsSKUs = @[];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    XCTAssertTrue(correspondanceArray.count == 0);
}

- (void)testNoProductsAndNoFavorites {
    self.wishlistSKUs = @[];
    self.productsSKUs = @[];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    XCTAssertTrue(correspondanceArray.count == 0);
}

- (void)testMixedProuctsAndWishlist {
    self.wishlistSKUs = @[@3, @2, @6, @8, @1];
    self.productsSKUs = @[@1, @2, @3, @4, @5];
    
    NSArray *correspondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:_wishlistSKUs sortedProductsSKUs:_productsSKUs];
    for (NSNumber *isFavorite in correspondanceArray) {
        XCTAssertTrue(isFavorite.boolValue == [_wishlistSKUs containsObject:_productsSKUs[[correspondanceArray indexOfObject:isFavorite]]]);
    }
}

@end
