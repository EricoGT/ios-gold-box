//
//  WBRRetargetingTests.m
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRRetargetingConnection.h"

@interface WBRRetargetingTests : XCTestCase
@property (nonatomic, strong) WBRRetargetingConnection *wbr;
@end

@implementation WBRRetargetingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _wbr = [WBRRetargetingConnection new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _wbr = nil;
    
    [super tearDown];
}

- (void)testRequestRetargetingShowcases {
    
    [_wbr requestRetargShowcases:@"" success:^(NSHTTPURLResponse *httpResponse) {
        XCTAssertEqual(httpResponse.statusCode, (NSUInteger)200);
    } failure:^(NSDictionary *dictError) {
    }];
    
//    NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
//    
//    [_wbr requestRetargShowcases:@"mock-error" success:^(NSHTTPURLResponse *httpResponse) {
//    } failure:^(NSDictionary *dictError) {
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
