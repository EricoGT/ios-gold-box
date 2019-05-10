//
//  CreditCardInteractorTests.m
//  Walmart
//
//  Created by Renan Cargnin on 3/22/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CreditCardInteractor.h"

@interface CreditCardInteractorTests : XCTestCase

@end

@implementation CreditCardInteractorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFlagAmex {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"378282246310005"];
    XCTAssertEqual(flag, CreditCardFlagAmex);
    flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"371449635398431"];
    XCTAssertEqual(flag, CreditCardFlagAmex);
}

- (void)testFlagVisa {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"4111111111111111"];
    XCTAssertEqual(flag, CreditCardFlagVisa);
    flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"4012888888881881"];
    XCTAssertEqual(flag, CreditCardFlagVisa);
}

- (void)testFlagMaster {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"5555555555554444"];
    XCTAssertEqual(flag, CreditCardFlagMaster);
    flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"5105105105105100"];
    XCTAssertEqual(flag, CreditCardFlagMaster);
}

- (void)testFlagDiners {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"30569309025904"];
    XCTAssertEqual(flag, CreditCardFlagDiners);
    flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"38520000023237"];
    XCTAssertEqual(flag, CreditCardFlagDiners);
}

- (void)testFlagHiper {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"6062825624254001"];
    XCTAssertEqual(flag, CreditCardFlagHiper);
}

- (void)testFlagElo {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"6362970000457013"];
    XCTAssertEqual(flag, CreditCardFlagElo);
}

- (void)testFlagUnrecognized {
    CreditCardFlag flag = [CreditCardInteractor creditCardFlagWithCardNumberString:@"87342836584564564"];
    XCTAssertEqual(flag, CreditCardFlagUnrecognized);
}

@end
