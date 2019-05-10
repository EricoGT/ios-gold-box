//
//  WBRCreditCardTests.m
//  WalmartTests
//
//  Created by Rafael Valim on 30/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBRCreditCard.h"

@interface WBRCreditCardTests : XCTestCase

@property (nonatomic, strong) WBRCreditCard *wbrCreditCard;

@end

@implementation WBRCreditCardTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.wbrCreditCard = [WBRCreditCard new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseMockData {
    [self.wbrCreditCard requestUserWalletWithSuccess:^(ModelWallet *userWallet) {
        
        //Checks if mock data has changed
        XCTAssertEqual(userWallet.maxCards, 10);
        XCTAssertEqual(userWallet.totalCards, 5);
        //Checks intrinsict object logic
        XCTAssertEqual(userWallet.creditCards.count, userWallet.totalCards);
        
    } andFailure:^(NSError *error, NSData *data) {
        XCTFail(@"Check your mock data %@", error);
    }];
}

@end
