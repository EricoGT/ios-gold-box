//
//  ProductDetailTests.m
//  Walmart
//
//  Created by Renan on 6/13/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ProductDetailModel.h"
#import "VariationNode.h"
#import "WBRRatingModel.h"
#import "WBRCompleteRatingView.h"

@interface ProductDetailTests : XCTestCase

@property (strong, nonatomic) ProductDetailModel *productDetail;

@property (strong, nonatomic) SellerOptionModel *firstSeller;
@property (strong, nonatomic) SellerOptionModel *secondSeller;
@property (strong, nonatomic) SellerOptionModel *thirdSeller;

@property (strong, nonatomic) WBRRatingModel *ratingModel;
@property (strong, nonatomic) WBRCompleteRatingView *completeRating;

@end

@interface WBRCompleteRatingView (Tests)
- (NSString *)evaluationStringWithNumberOfRatings:(NSNumber *)numberOfRatings;
@end

@implementation ProductDetailTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.productDetail = [ProductDetailModel new];
    
    self.firstSeller = [SellerOptionModel new];
    self.secondSeller = [SellerOptionModel new];
    self.thirdSeller = [SellerOptionModel new];
    
    self.ratingModel = [WBRRatingModel new];
    
    NSArray<SellerOptionModel> *sellerOptions = (NSArray<SellerOptionModel> *) @[_firstSeller, _secondSeller, _thirdSeller];
    
    [_productDetail setSellerOptions:sellerOptions];
    
    VariationNode *treeNode = [VariationNode new];
    [_productDetail setVariationsTree:treeNode];
    
    _completeRating = [WBRCompleteRatingView new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _completeRating = nil;
    
    [super tearDown];
}


- (void)testRating {

    //The rating model should discard any values that are below 0 and above 5
    //protecting itself against a faulty value being returned by the server
    
    _ratingModel.ratingValue = [NSNumber numberWithInt:10];
    XCTAssertEqual(_ratingModel.ratingValue, @5);
    
    _ratingModel.ratingValue = [NSNumber numberWithInt:-10];
    XCTAssertEqual(_ratingModel.ratingValue, @0);
}

- (void)DISABLED_testvaluationStringWithNumberOfRatings {
    
    NSString *strForLabelUnique = [_completeRating evaluationStringWithNumberOfRatings:[NSNumber numberWithInt:1]];
    XCTAssertTrue([strForLabelUnique isEqualToString:@"1 Avaliação"], @"Strings are not equal");
    
    NSString *strForLabelDouble = [_completeRating evaluationStringWithNumberOfRatings:[NSNumber numberWithInt:10]];
    XCTAssertTrue([strForLabelDouble isEqualToString:@"10 Avaliações"], @"Strings are not equal");
}

//- (void)testEvaluationLabelString {
//    _ratingModel.ratingValue = [NSNumber numberWithInt:3];
//    _ratingModel.totalOfRatings = [NSNumber numberWithInt:1];
//    
//    WBRCompleteRatingView *completeRatingView = [[WBRCompleteRatingView alloc] init];
//    completeRatingView.rating = _ratingModel;
//    
//    NSRange range = [completeRatingView.evaluationLabel.text rangeOfString:@"Avaliação"];
//    XCTAssertNotEqual(range.location, NSNotFound);
//    
//    _ratingModel.totalOfRatings = [NSNumber numberWithInt:2];
//    completeRatingView.rating = _ratingModel;
//    range = [completeRatingView.evaluationLabel.text rangeOfString:@"Avaliações"];
//    XCTAssertNotEqual(range.location, NSNotFound);
//}

- (void)testTitle {
    [_productDetail setTitle:@"Fog&#227;o 4 Bocas - Marca"];
    XCTAssertEqualObjects(_productDetail.title, @"Fogão 4 Bocas - Marca");
}

//- (void)testImageIds {
//    NSArray *imageIds = @[@"0", @"1", @"2"];
//    [_productDetail setImageIds:imageIds];
//    
//    NSArray *expectedImageIds = @[@"0", @"1"];
//    XCTAssertEqualObjects(expectedImageIds, _productDetail.imageIds);
//}

//- (void)testDefaultSKU {
//    [_firstSeller setSku:@123];
//    [_secondSeller setSku:@456];
//    [_thirdSeller setSku:@789];
//    
//    SellerOptionModel *firstSeller = _productDetail.sellerOptions.firstObject;
//    XCTAssertEqualObjects(firstSeller.sku, _productDetail.defaultSKU);
//    
//    _productDetail.sellerOptions = nil;
//    XCTAssertNil(_productDetail.defaultSKU);
//}

- (void)testDefaultSeller {
    XCTAssertEqual(_productDetail.defaultSeller, _productDetail.sellerOptions.firstObject);
    
    _productDetail.sellerOptions = nil;
    XCTAssertNil(_productDetail.defaultSeller);
}

- (void)testOtherSellers {
    NSMutableArray *sellerOptionsMutable = _productDetail.sellerOptions.mutableCopy;
    [sellerOptionsMutable removeObjectAtIndex:0];
    XCTAssertEqualObjects(sellerOptionsMutable.copy, _productDetail.otherSellers);
    
    SellerOptionModel *firstSeller = _productDetail.sellerOptions.firstObject;
    _productDetail.sellerOptions = (NSArray<SellerOptionModel> *) @[firstSeller];
    XCTAssertNil(_productDetail.otherSellers);
    
    _productDetail.sellerOptions = nil;
    XCTAssertNil(_productDetail.otherSellers);
}

- (void)testSellerWithId {
    [_firstSeller setSellerId:@"123"];
    [_secondSeller setSellerId:@"456"];
    [_thirdSeller setSellerId:@"789"];
    
    XCTAssertEqual(_firstSeller, [_productDetail sellerWithId:@"123"]);
    XCTAssertEqual(_secondSeller, [_productDetail sellerWithId:@"456"]);
    XCTAssertEqual(_thirdSeller, [_productDetail sellerWithId:@"789"]);
    XCTAssertNil([_productDetail sellerWithId:@"101112"]);
    XCTAssertNil([_productDetail sellerWithId:nil]);
}

//- (void)testIsAvailable {
//    [_firstSeller setQuantityAvailable:@2];
//    [_secondSeller setQuantityAvailable:@0];
//    [_thirdSeller setQuantityAvailable:@1];
//    XCTAssertTrue(_productDetail.isAvailable);
//    
//    [_thirdSeller setQuantityAvailable:@0];
//    XCTAssertTrue(_productDetail.isAvailable);
//    
//    [_firstSeller setQuantityAvailable:@0];
//    XCTAssertFalse(_productDetail.isAvailable);
//}

- (void)testHasVariations {
    [_productDetail.variationsTree setOptions:@[[VariationNode new], [VariationNode new]]];
    XCTAssertTrue(_productDetail.hasVariations);
    
    [_productDetail.variationsTree setOptions:nil];
    XCTAssertFalse(_productDetail.hasVariations);
}

//- (void)DISABLED_testIsFavorite {
//    [_productDetail.variationsTree setOptions:@[[VariationNode new], [VariationNode new]]];
//    SellerOptionModel *defaultSeller = _productDetail.defaultSeller;
//    defaultSeller.wishlist = NO;
//    XCTAssertEqual(_productDetail.isFavorite, defaultSeller.wishlist);
//    defaultSeller.wishlist = YES;
//    XCTAssertEqual(_productDetail.isFavorite, defaultSeller.wishlist);
//    
//    [_productDetail.variationsTree setOptions:nil];
//    _productDetail.wishlist = YES;
//    XCTAssertEqual(YES, _productDetail.isFavorite);
//    _productDetail.wishlist = NO;
//    XCTAssertEqual(NO, _productDetail.isFavorite);
//}

//- (void)testSetIsFavorite {
//    [_productDetail.variationsTree setOptions:@[[VariationNode new], [VariationNode new]]];
//    SellerOptionModel *defaultSeller = _productDetail.defaultSeller;
//    defaultSeller.wishlist = NO;
//    [_productDetail setIsFavorite:YES];
//    XCTAssertTrue(defaultSeller.wishlist);
//    
//    [_productDetail.variationsTree setOptions:nil];
//    _productDetail.wishlist = NO;
//    [_productDetail setIsFavorite:YES];
//    XCTAssertTrue(_productDetail.wishlist);
//}

@end
