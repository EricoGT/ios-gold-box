//
//  WBRShippingDeliveryCellTests.m
//  Walmart
//
//  Created by Guilherme on 8/14/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ShippingDeliveryCell.h"

@interface ShippingDeliveryCell (Tests)

- (NSString *)formattedDataWithUTCTime:(NSNumber *)UTCTime;

@end

@interface WBRShippingDeliveryCellTests : XCTestCase

@property (strong, nonatomic) ShippingDeliveryCell *shippingDeliveryCell;

@end

@implementation WBRShippingDeliveryCellTests

- (void)setUp {
    [super setUp];
    
    self.shippingDeliveryCell = [ShippingDeliveryCell new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)DISABLED_testFormattedDataWithDelivery {
    
    NSNumber *date1 = @(1508248800000); // Tuesday, October 17, 2017 2:00:00 PM
    NSString *expectedString1 = @"17/10/2017";
    NSNumber *date2 = @(0); // Thursday, January 1, 1970 12:00:00 AM
    NSString *expectedString2 = @"01/01/1970";
    NSNumber *date3 = @(1546300800); // Tuesday, January 1, 2019 12:00:00 AM
    NSString *expectedString3 = @"01/01/2019";
    
    NSString *resultString1 = [self.shippingDeliveryCell formattedDataWithUTCTime:date1];
    XCTAssertTrue([expectedString1 isEqualToString:resultString1]);
    NSString *resultString2 = [self.shippingDeliveryCell formattedDataWithUTCTime:date2];
    XCTAssertTrue([expectedString2 isEqualToString:resultString2]);
    NSString *resultString3 = [self.shippingDeliveryCell formattedDataWithUTCTime:date3];
    XCTAssertTrue([expectedString3 isEqualToString:resultString3]);
}

@end
