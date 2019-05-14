//
//  WBRHomeTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/8/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRHomeManager.h"

@interface WBRHomeManager ()

+ (void) getHomeStaticOriginal:(void (^)(NSData *dataJson))success failure:(void (^)(NSError *error))failure;

+ (void) getHomeDynamicOriginal:(void (^)(NSData *dataJson))success failure:(void (^)(NSError *error))failure;

@end

@interface WBRHomeManagerTests : XCTestCase

@end

@implementation WBRHomeManagerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetHomeStaticOriginal {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"staticHome" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    [WBRHomeManager getHomeStaticOriginal:^(NSData *dataJson) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSError *error) {
    }];
}

- (void)testGetHomeDynamicOriginal {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dynamicHome" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    [WBRHomeManager getHomeDynamicOriginal:^(NSData *dataJson) {
        XCTAssertEqualObjects(jsonData, dataJson);
    } failure:^(NSError *error) {
    }];
}

@end
