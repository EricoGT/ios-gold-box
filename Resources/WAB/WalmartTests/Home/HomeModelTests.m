//
//  HomeModelTests.m
//  Walmart
//
//  Created by Renan on 6/15/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "HomeModel.h"

@interface HomeModelTests : XCTestCase

@property (strong, nonatomic) HomeModel *home;

@property (strong, nonatomic) NSArray *validShowcases;
@property (strong, nonatomic) NSArray *invalidShowcases;

@end

@implementation HomeModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.home = [HomeModel new];
    
    NSMutableArray *validShowcasesMutable = [NSMutableArray new];
    NSMutableArray *invalidShowcasesMutable = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 3; i++) {
        ShowcaseModel *validShowcase = [ShowcaseModel new];
        [validShowcase setProducts:(NSArray<ShowcaseProductModel> *) @[[ShowcaseProductModel new], [ShowcaseProductModel new]]];
        [validShowcasesMutable addObject:validShowcase];
        
        ShowcaseModel *invalidShowcase = [ShowcaseModel new];
        [invalidShowcase setProducts:(NSArray<ShowcaseProductModel> *) @[]];
        [invalidShowcasesMutable addObject:invalidShowcase];
    }
    
    self.validShowcases = validShowcasesMutable.copy;
    self.invalidShowcases = invalidShowcasesMutable.copy;
}

- (void)testSetShowcases {
    NSArray<ShowcaseModel> *showcases = (NSArray<ShowcaseModel> *) [_validShowcases arrayByAddingObjectsFromArray:_invalidShowcases];
    [_home setShowcases:showcases];
    XCTAssertEqualObjects(_home.showcases, _validShowcases);
    
    showcases = (NSArray<ShowcaseModel> *) [_invalidShowcases arrayByAddingObjectsFromArray:_validShowcases];
    [_home setShowcases:showcases];
    XCTAssertEqualObjects(_home.showcases, _validShowcases);
    
    showcases = (NSArray<ShowcaseModel> *) _invalidShowcases;
    [_home setShowcases:showcases];
    XCTAssertEqualObjects(_home.showcases, @[]);
}

- (void)testProductsWithSKU {
    ShowcaseProductModel *productA = [ShowcaseProductModel new];
    productA.skuId = @123;
    
    ShowcaseProductModel *productB = [ShowcaseProductModel new];
    productB.skuId = @456;
    
    ShowcaseProductModel *productC = [ShowcaseProductModel new];
    productC.skuId = @789;
    
    ShowcaseProductModel *productD = [ShowcaseProductModel new];
    productD.skuId = @101112;
    
    ShowcaseProductModel *productE = [ShowcaseProductModel new];
    productE.skuId = @131415;
    
    ShowcaseProductModel *productF = [ShowcaseProductModel new];
    productF.skuId = @123;
    
    ShowcaseModel *showcaseA = [ShowcaseModel new];
    [showcaseA setProducts:(NSArray<ShowcaseProductModel> *) @[productA, productC, productE]];
    
    ShowcaseModel *showcaseB = [ShowcaseModel new];
    [showcaseB setProducts:(NSArray<ShowcaseProductModel> *) @[productF, productB, productD]];
    
    [_home setShowcases:(NSArray<ShowcaseModel> *) @[showcaseA, showcaseB]];
    
    NSArray *products = [_home productsWithSKU:productA.skuId];
    NSArray *expectedProducts = @[productA, productF];
    XCTAssertEqualObjects(expectedProducts, products);
    
    products = [_home productsWithSKU:productB.skuId];
    expectedProducts = @[productB];
    XCTAssertEqualObjects(expectedProducts, products);
    
    products = [_home productsWithSKU:@0];
    expectedProducts = @[];
    XCTAssertEqualObjects(expectedProducts, products);
}

@end
