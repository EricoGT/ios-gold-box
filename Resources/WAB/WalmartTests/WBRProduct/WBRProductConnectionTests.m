//
//  WBRProductConnectionTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/8/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRProductConnection.h"
#import "PaymentItem.h"
#import "PaymentType.h"

@interface WBRProductConnectionTests : XCTestCase
@property (nonatomic, strong) WBRProductConnection *wbpc;
@end

@implementation WBRProductConnectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _wbpc = [WBRProductConnection new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _wbpc = nil;
    
    [super tearDown];
}

- (void)testRequestSearchQuery {
    
    //Success Test
    
    NSString *fileName = @"mock-products";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbpc requestSearchQuery:@"" sortParameter:@"" successBlock:^(NSData *jsonData) {
        
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
    /*
    //Fail Test
    
    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
    
    [_wbpc requestSearchQuery:@"error-mock" sortParameter:@"" successBlock:^(NSData *jsonData) {
    } failure:^(NSDictionary *dictError) {
        
        XCTAssertEqualObjects(dictErrorMock, dictError);
    }];
     */
}

- (void)testRequestProductDetail {
    
    //Success Test
    
    NSString *fileName = @"mock-product-detail";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];

    [_wbpc requestProductDetail:@"" showcaseId:@"" successBlock:^(NSData *jsonData) {
        
         XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
    /*
    //Fail Test
    
    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
    
    [_wbpc requestProductDetail:@"error-mock" showcaseId:@"" successBlock:^(NSData *jsonData) {
    } failure:^(NSDictionary *dictError) {
        
        XCTAssertEqualObjects(dictErrorMock, dictError);
    }];
     */
}

- (void)testRequestPaymentForms {
    
    //Success Test
    
    NSString *fileName = @"mock-paymentForms";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataJson options:kNilOptions error:nil];
    PaymentForms *paymentMock = [[PaymentForms alloc] initWithDictionary:dictJson error:nil];
    PaymentItem *itemPaymentsMock = paymentMock.payments[0];
    PaymentType *paymentTypeMock = itemPaymentsMock.paymentType;
    
    [_wbpc requestPaymentForms:@{@"test":@"test"} successBlock:^(PaymentForms *payment) {
        
        PaymentItem *itemPayments = payment.payments[0];
        PaymentType *paymentType = itemPayments.paymentType;
        
        XCTAssertEqualObjects(paymentType.name, paymentTypeMock.name);
        XCTAssertEqualObjects(paymentType.type, paymentTypeMock.type);
        
    } failure:^(NSDictionary *dictError) {
    }];
    
    /*
    //Fail Test
    
    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
    
    [_wbpc requestPaymentForms:@{@"test" : @"error-mock"} successBlock:^(PaymentForms *payment) {
    } failure:^(NSDictionary *dictError) {
        
        XCTAssertEqualObjects(dictErrorMock, dictError);
    }];
     */
}

- (void)testRequestWarrantyProductDetail {
    
    //Success Test
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-warranty" ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbpc requestWarrantyProductDetail:@"" sellerId:@"" sellPrice:@0 successBlock:^(NSData *jsonData) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
    /*
    //Fail Test
    
    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
    
    [_wbpc requestWarrantyProductDetail:@"error-mock" sellerId:@"" sellPrice:@0 successBlock:^(NSData *jsonData) {
    } failure:^(NSDictionary *dictError) {
        
        XCTAssertEqualObjects(dictErrorMock, dictError);
    }];
     */
}

- (void)testRequestProductReviews {
    
    //Success Test
    
    NSString *fileName = @"mock-product-reviews";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *dataJson = [NSData dataWithContentsOfFile:filePath];
    
    [_wbpc requestProductReviews:@"" successBlock:^(NSData *jsonData) {
        
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSDictionary *dictError) {
    }];
    
    /*
    //Fail Test
    
    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
    
    [_wbpc requestProductReviews:@"error-mock" successBlock:^(NSData *jsonData) {
    } failure:^(NSDictionary *dictError) {
        
        XCTAssertEqualObjects(dictErrorMock, dictError);
    }];
     */
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
