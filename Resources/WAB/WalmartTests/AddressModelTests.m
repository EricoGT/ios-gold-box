//
//  AddressModelTests.m
//  Walmart
//
//  Created by Renan on 5/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AddressModel.h"
#import "NSString+HTML.h"

@interface AddressModelTests : XCTestCase {
    AddressModel *address;
}

@end

@implementation AddressModelTests

- (void)setUp {
    [super setUp];
    
    address = [AddressModel new];
    address.addressId = @"1";
    address.receiverName = @"Renan Cargnin";
    address.type = @"Comercial";
    address.street = @"Rua Estero Belaco";
    address.number = @"160";
    address.complement = @"Apto 72";
    address.neighborhood = @"Vila da Saúde";
    address.city = @"São Paulo";
    address.state = @"SP";
    address.zipcode = @"04145020";
    address.defaultAddress = @YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testType {
    address.type = @"Comercial";
    XCTAssertTrue([[address JSONObjectForType] isEqualToString:@"Business"]);
    address.type = @"Residencial";
    XCTAssertTrue([[address JSONObjectForType] isEqualToString:@"Residential"]);
}

- (void)DISABLED_testFullAddress {
    NSString *fullAddressFormat = [NSString stringWithFormat:@"%@, %@ %@\n%@ - %@ - %@\nCEP: %@", address.street, address.number, address.complement, address.neighborhood, address.city, address.state, address.zipcode];
    XCTAssertTrue([address.fullAddress isEqualToString:fullAddressFormat]);
    
    address.number = nil;
    fullAddressFormat = [NSString stringWithFormat:@"%@ %@\n%@ - %@ - %@\nCEP: %@", address.street, address.complement, address.neighborhood, address.city, address.state, address.zipcode];
    XCTAssertTrue([address.fullAddress isEqualToString:fullAddressFormat]);
    
    address.number = @"160";
    address.complement = nil;
    fullAddressFormat = [NSString stringWithFormat:@"%@, %@\n%@ - %@ - %@\nCEP: %@", address.street, address.number, address.neighborhood, address.city, address.state, address.zipcode];
    XCTAssertTrue([address.fullAddress isEqualToString:fullAddressFormat]);
    
    address.complement = @"Apto 72";
    address.neighborhood = nil;
    fullAddressFormat = [NSString stringWithFormat:@"%@, %@ %@\n%@ - %@\nCEP: %@", address.street, address.number, address.complement, address.city, address.state, address.zipcode];
    XCTAssertTrue([address.fullAddress isEqualToString:fullAddressFormat]);
}

- (void)testStreetNameWithComplement {
    
    NSString *decodeStreetNameStrint = [address.street kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithNumber = [NSString stringWithFormat:@"%@, %@ - %@", decodeStreetNameStrint, address.number, address.complement];
    XCTAssertTrue([expectedStringWithNumber isEqualToString:[address streetNameWithComplement]]);
}

- (void)testStreetNameWithComplementWithoutNumber {
    address.number = @"";
    NSString *decodeStreetNameStrint = [address.street kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutNumber = [NSString stringWithFormat:@"%@, S/N - %@", decodeStreetNameStrint, address.complement];
    XCTAssertTrue([expectedStringWithoutNumber isEqualToString:[address streetNameWithComplement]]);
}

- (void)testStreetNameWithComplementWithoutComplement {
    address.complement = @"";
    NSString *decodeStreetNameStrint = [address.street kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutComplement = [NSString stringWithFormat:@"%@, %@", decodeStreetNameStrint, address.number];
    XCTAssertTrue([expectedStringWithoutComplement isEqualToString:[address streetNameWithComplement]]);
}

- (void)testStreetNameWithComplementWithoutComplementAndNumber {
    address.complement = @"";
    address.number = kAddressNoNumberDefaultValue;
    NSString *decodeStreetNameStrint = [address.street kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutComplement = [NSString stringWithFormat:@"%@, %@", decodeStreetNameStrint, kAddressNoNumberDefaultString];
    XCTAssertTrue([expectedStringWithoutComplement isEqualToString:[address streetNameWithComplement]]);
}

- (void)testAdditionalInformationSuccess {
    NSString *expectedString = [NSString stringWithFormat:@"%@ - %@ - %@", address.neighborhood, address.city, address.state];
    XCTAssertTrue([expectedString isEqualToString:[address additionalInformation]]);
}

@end
