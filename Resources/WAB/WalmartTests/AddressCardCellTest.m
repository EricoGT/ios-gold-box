//
//  AddressCardCellTest.m
//  Walmart
//
//  Created by Renan on 5/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+HTML.h"

#import "AddressModel.h"
#import "AddressCardCell.h"

@interface AddressCardCellTest : XCTestCase {
    AddressModel *address;
    AddressCardCell *addressCard;
}

@end

@implementation AddressCardCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSDictionary *addressDict = @{@"id" : @"1",
                                  @"receiverName" : @"Renan Cargnin",
                                  @"type" : @"Business",
                                  @"street" : @"Rua Estero Belaco",
                                  @"number" : @"160",
                                  @"complement" : @"Apto 72",
                                  @"neighborhood" : @"Vila da Saúde",
                                  @"city" : @"São Paulo",
                                  @"state" : @{@"id" : @"SP"},
                                  @"zipcode" : @"04145020",
                                  @"defaultAddress" : @NO,
                                  @"country" : @{@"name" : @"BR"}};
    
    NSError *parserError;
    address = [[AddressModel alloc] initWithDictionary:addressDict error:&parserError];
    XCTAssertNil(parserError);
    
    addressCard = [[AddressCardCell alloc] initForTestCase];
    [addressCard setupWithAddress:address];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCardInfo {
    
    XCTAssertEqual(addressCard.receiverNameLabel.text, address.receiverName, @"Receiver name is wrong");
    
    NSString *decodeStreetString = [address.street kv_decodeHTMLCharacterEntities];
    NSString *expectedStreetString = [NSString stringWithFormat:@"%@, %@ - %@", decodeStreetString, address.number, address.complement];
    XCTAssertTrue([expectedStreetString isEqualToString:addressCard.streetLabel.text], @"Street string is wrong");
    
    NSString *expectedComplementString = [NSString stringWithFormat:@"%@ - %@ - %@", address.neighborhood, address.city, address.state];
    XCTAssertTrue([expectedComplementString isEqualToString:addressCard.complementLabel.text], @"Complement string is wrong");
}

@end
