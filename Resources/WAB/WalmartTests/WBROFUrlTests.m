//
//  WBROFUrlTests.m
//  WalmartTests
//
//  Created by Guilherme Nunes Ferreira on 4/17/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WBRContactManagerUrls.h"

@interface WBROFUrlTests : XCTestCase

@end

@implementation WBROFUrlTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testQueryParameterToURL {

    NSString *url = [WBRContactManagerUrls urlContactRequestOrders];

    NSString *expectedUrlWithNotCancelledTrue = [NSString stringWithFormat:@"%@?notCancelled=true", url];
    NSString *urlWithNotCancelledTrue = [OFUrls addQueryParameterToURL:url queryParameter:@"notCancelled" value:YES];
    XCTAssertTrue([expectedUrlWithNotCancelledTrue isEqualToString:urlWithNotCancelledTrue]);

    NSString *expectedUrlWithNotCancelledFalse = [NSString stringWithFormat:@"%@?notCancelled=false", url];
    NSString *urlWithNotCancelledFalse = [OFUrls addQueryParameterToURL:url queryParameter:@"notCancelled" value:NO];
    XCTAssertTrue([expectedUrlWithNotCancelledFalse isEqualToString:urlWithNotCancelledFalse]);

    NSString *expectedUrlWithNotCancelledFalseWithWarrantyTrue = [NSString stringWithFormat:@"%@?notCancelled=false&withWarranty=true", url];
    NSString *urlWithNotCancelledFalseWithWarrantyTrue = [OFUrls addQueryParameterToURL:url queryParameter:@"notCancelled" value:NO];
    urlWithNotCancelledFalseWithWarrantyTrue = [OFUrls addQueryParameterToURL:urlWithNotCancelledFalseWithWarrantyTrue queryParameter:@"withWarranty" value:YES];

    XCTAssertTrue([expectedUrlWithNotCancelledFalseWithWarrantyTrue isEqualToString:urlWithNotCancelledFalseWithWarrantyTrue]);
}

@end
