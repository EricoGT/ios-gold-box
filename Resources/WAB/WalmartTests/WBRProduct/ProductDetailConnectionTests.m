//
//  ProductDetailConnectionTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/30/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductDetailConnection.h"
#import "ProductDetailModel.h"

@interface ProductDetailConnectionTests : XCTestCase
@property (nonatomic, strong) ProductDetailConnection *pdc;
@end

@interface ProductDetailConnection (Tests)

- (void)loadProductWithBasePath:(NSString *)basePath showcaseId:(NSString *)showcaseId success:(void (^)(ProductDetailModel *))success failure:(void (^)(NSError *))failure;
- (void)loadVariationsTreeWithProductId:(NSString *)productId completionBlock:(void (^)(VariationNode *variationTree, NSString *baseImageURL))success failure:(void (^)(NSError *error))failure;

@end

@implementation ProductDetailConnectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _pdc = [ProductDetailConnection new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _pdc = nil;
    
    [super tearDown];
}

- (void)DISABLED_testLoadProductWithBasePath {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    ProductDetailModel *productDetail = [[ProductDetailModel alloc] initWithDictionary:dictJson[@"product"] error:nil];
    
    [_pdc loadProductWithBasePath:@"" showcaseId:@"" success:^(ProductDetailModel *product) {
        
        XCTAssertEqualObjects(product.imagesIds, productDetail.imagesIds);
        XCTAssertEqualObjects(product.productId, productDetail.productId);
        XCTAssertEqualObjects(product.standardSku, productDetail.standardSku);
        XCTAssertEqualObjects(product.title, productDetail.title);
        XCTAssertEqualObjects(product.sellerOptions, productDetail.sellerOptions);
        XCTAssertEqualObjects(product.ratingValue, productDetail.ratingValue);
        XCTAssertEqualObjects(product.ratingTotal, productDetail.ratingTotal);
        XCTAssertEqualObjects(product.stampUrl, productDetail.stampUrl);
        XCTAssertEqualObjects(product.stampTitle, productDetail.stampTitle);
        XCTAssertEqualObjects(product.stampDescription, productDetail.stampDescription);
        XCTAssertEqualObjects(product.stampFullDescription, productDetail.stampFullDescription);
        XCTAssertEqualObjects(product.deliveryStampUrl, productDetail.deliveryStampUrl);
        
    } failure:^(NSError *error) {
    }];
}


//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
