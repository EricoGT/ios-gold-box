//
//  WBRWishlistTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/12/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRWishlist.h"

@interface WBRWishlistTests : XCTestCase
@property (nonatomic, strong) WBRWishlist *wbw;
@end

@implementation WBRWishlistTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _wbw = [WBRWishlist new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _wbw = nil;
    
    [super tearDown];
}

- (void)testGetWishlist {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    [_wbw getWishlist:^(NSDictionary *dictWishlist) {
        XCTAssertEqualObjects(dictJson, dictWishlist);
    } failure:^(NSError *error, NSData *data) {
        
    }];
    
    //    NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:99 userInfo:@{NSLocalizedDescriptionKey : ERROR_UNKNOWN_CATEGORY}];
}

- (void)testGetWishlistSku {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-skus" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    [_wbw getWishlistSku:^(NSDictionary *dictWishlist) {
        XCTAssertEqualObjects(dictJson, dictWishlist);
    } failure:^(NSError *error, NSData *data) {
        
    }];
}

- (void)testAddWishlistProductWithSku {
    
    __block BOOL isOk = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [_wbw addWishlistProductWithSku:@"" productId:@"" sellerId:@"" completion:^(BOOL success, NSError *error, NSData *data) {
        
        isOk = success;
        dispatch_semaphore_signal(semaphore);
    }];
    
    XCTAssertTrue(isOk);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testDelWishlistProductWithSku {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-del" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    [_wbw delWishlistProductWithSku:@[] success:^(NSData *data) {
        XCTAssertEqualObjects(jsonData, data);
    } failure:^(NSError *error, NSData *dataError) {
    }];
}

- (void)testBoughtWishlistProductWithSku {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-bought" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    [_wbw boughtWishlistProductWithSku:@[] success:^(NSData *data) {
         XCTAssertEqualObjects(jsonData, data);
    } failure:^(NSError *error, NSData *dataError) {
    }];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
