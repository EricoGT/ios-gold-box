//
//  ShipAddressCellTests.m
//  Walmart
//
//  Created by Marcelo Santos on 3/6/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShipAddressCell.h"
#import "NSString+HTML.h"

@interface ShipAddressCellTests : XCTestCase
@property (nonatomic, strong) ShipAddressCell *sac;
@end

@interface ShipAddressCell (Tests)
@property (nonatomic, weak) NSString *complement;
@property (nonatomic, weak) NSString *address;
@property (nonatomic, weak) NSString *address2;
@property (nonatomic, weak) NSString *strStreet;
@end

@implementation ShipAddressCellTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _sac = [[ShipAddressCell alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _sac = nil;
    
    [super tearDown];
}

- (void)testSetupWithAddressDict {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary *dictToTest = @{@"receiverName"    : @"Walmart Brasil",
                                 @"complement"      : @"Alphaville",
                                 @"street"          : @"Rua Walmart",
                                 @"number"          : @"12345",
                                 @"neighborhood"    : @"Industrial",
                                 @"postalCode"      : @"06485-370",
                                 @"referencePoint"  : @"Referencia"
                                 };
    
    [_sac setupWithAddressDict:dictToTest];
    
    NSString *correctAddress = [NSString stringWithFormat:@"%@, %@, %@", [dictToTest objectForKey:@"street"], [dictToTest objectForKey:@"number"], [dictToTest objectForKey:@"complement"]];
    correctAddress = [correctAddress kv_decodeHTMLCharacterEntities];
    
    LogInfo(@"Cor: %@", correctAddress);
    LogInfo(@"Add: %@", _sac.address);
    
    XCTAssertEqualObjects(_sac.complement, [dictToTest objectForKey:@"complement"], @"FAIL: %@", _sac.complement);
    XCTAssertEqualObjects(_sac.address, correctAddress, @"FAIL: %@", _sac.address);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
