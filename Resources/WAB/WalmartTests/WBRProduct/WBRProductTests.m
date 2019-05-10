//
//  WBRProductTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/8/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRProduct.h"

@interface WBRProductTests : XCTestCase
@property (nonatomic, strong) WBRProduct *wbp;
@end

@interface WBRProduct (Tests)

@end

@implementation WBRProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _wbp = [WBRProduct new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _wbp = nil;
    
    [super tearDown];
}

- (void)testGetSearch {

    //Success Test
    
    NSString *fileName = @"mock-products";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    [_wbp getSearchWithQuery:@"" sortParameter:@"" successBlock:^(NSData *dataJson) {
        
        XCTAssertEqualObjects(jsonData, dataJson);
        
    } failureBlock:^(NSDictionary *dictError) {
    }];
    
//    //Fail Test
//
//    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
//
//    [_wbp getSearchWithQuery:@"error-mock" sortParameter:@"" successBlock:^(NSData *dataJson) {
//    } failureBlock:^(NSDictionary *dictError) {
//
//        XCTAssertEqualObjects(dictErrorMock, dictError);
//    }];
}

- (void)testGetProductDetail {
    
    //Success Test
    
    NSString *fileName = @"mock-product-detail";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbp getProductDetail:@"" showcaseId:@"" successBlock:^(NSData *jsonData) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
//    //Fail Test
//
//    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
//
//    [_wbp getProductDetail:@"error-mock" showcaseId:@"" successBlock:^(NSData *jsonData) {
//    } failure:^(NSDictionary *dictError) {
//
//        XCTAssertEqualObjects(dictErrorMock, dictError);
//    }];
    
}

- (void)testGetWarranty {
    
    //Success Test
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-warranty" ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbp getWarrantyProductDetail:@"" sellerId:@"" sellPrice:@0 successBlock:^(NSData *jsonData) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
//    //Fail Test
//
//    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
//
//    [_wbp getWarrantyProductDetail:@"error-mock" sellerId:@"" sellPrice:@0 successBlock:^(NSData *jsonData) {
//    } failure:^(NSDictionary *dictError) {
//
//        XCTAssertEqualObjects(dictErrorMock, dictError);
//    }];

}

- (void)testGetProductReviews {
    
    //Success Test
    
    NSString *fileName = @"mock-product-reviews";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbp getProductReviews:@"" successBlock:^(NSData *jsonData) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
//    //Fail Test
//    
//    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
//    
//    [_wbp getProductReviews:@"error-mock"  successBlock:^(NSData *jsonData) {
//    } failure:^(NSDictionary *dictError) {
//        
//        XCTAssertEqualObjects(dictErrorMock, dictError);
//    }];
    
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
