//
//  CardPaymentCellTests.m
//  Walmart
//
//  Created by Marcelo Santos on 10/27/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardPaymentCell.h"

@interface CardPaymentCellTests : XCTestCase

@end

@implementation CardPaymentCellTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testVisa {
    
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"4929101092041165"];
    XCTAssertTrue([strCard isEqualToString:@"visa"], @"The value should be: 'visa'");
}

- (void) testAmex {
    
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"372870492038183"];
    XCTAssertTrue([strCard isEqualToString:@"amex"], @"The value should be: 'amex'");
}

- (void) testMastercard {
    
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"5435210678363481"];
    XCTAssertTrue([strCard isEqualToString:@"mastercard"], @"The value should be: 'mastercard'");
}

- (void) testDiners {
    
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"30363128509896"];
    XCTAssertTrue([strCard isEqualToString:@"diners"], @"The value should be: 'diners'");
}

- (void) testHiper {
    
//    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"3841001111222233334"];
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"6062828354795797"];
    XCTAssertTrue([strCard isEqualToString:@"hiper"], @"The value should be: 'hiper'");
}

- (void) testElo {
    
    NSString *strCard = [[CardPaymentCell new] getNameCardWithNumber:@"6362972283482973"];
    XCTAssertTrue([strCard isEqualToString:@"elo"], @"The value should be: 'elo'");
}

@end
