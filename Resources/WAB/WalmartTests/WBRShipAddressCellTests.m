//
//  WBRShipAddressCellTests.m
//  Walmart
//
//  Created by Guilherme Ferreira on 31/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ShipAddressCell.h"
#import "AddressModel.h"
#import "NSString+HTML.h"

@interface WBRShipAddressCellTests : XCTestCase

@property (strong, nonatomic) ShipAddressCell *shipAddressCell;
@property (strong, nonatomic) NSDictionary *addressPropertiesDictionary;

@end

@interface ShipAddressCell (Tests)

- (NSString *)streetLabelContentWithName:(NSString *)streetName withNumber:(NSString *)number  withComplement:(NSString *)complement;
- (NSString *)additionalInformationWithNeighborhood:(NSString *)neighborhood withCity:(NSString *)city withState:(NSString *)state;
- (NSString *)formatZipcodeString:(NSString *)zipcode;

@end

@implementation WBRShipAddressCellTests

- (void)setUp {
    [super setUp];
    
    self.shipAddressCell = [ShipAddressCell new];
    
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc] init];
    [contentDictionary setObject:@"Renan Cargnin" forKey:@"receiverName"];
    [contentDictionary setObject:@"Comercial" forKey:@"description"];
    [contentDictionary setObject:@"Rua Estero Belaco" forKey:@"street"];
    [contentDictionary setObject:@"Apto 72" forKey:@"complement"];
    [contentDictionary setObject:@"160" forKey:@"number"];
    [contentDictionary setObject:@"Vila da Saúde" forKey:@"neighborhood"];
    [contentDictionary setObject:@"São Paulo" forKey:@"city"];
    [contentDictionary setObject:@"SP" forKey:@"state"];
    [contentDictionary setObject:@"04145020" forKey:@"postalCode"];
    [contentDictionary setObject:@YES forKey:@"defaultAddress"];
    
    self.addressPropertiesDictionary = [[NSDictionary alloc] initWithDictionary:contentDictionary];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStreetNameWithComplement {
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressStreet = [self.addressPropertiesDictionary objectForKey:@"street"];
    NSString *addressNumber = [self.addressPropertiesDictionary objectForKey:@"number"];
    NSString *addressComplement = [self.addressPropertiesDictionary objectForKey:@"complement"];
    
    NSString *decodeStreetNameStrint = [addressStreet kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithNumber = [NSString stringWithFormat:@"%@, %@ - %@", decodeStreetNameStrint, addressNumber, addressComplement];
    
    NSString *resultString = [self.shipAddressCell streetLabelContentWithName:addressStreet withNumber:addressNumber withComplement:addressComplement];
    XCTAssertTrue([expectedStringWithNumber isEqualToString:resultString]);
}

- (void)testStreetNameWithComplementWithoutNumber {

    NSMutableDictionary *addressProperties = [[NSMutableDictionary alloc] initWithDictionary:self.addressPropertiesDictionary];
    [addressProperties setObject:@"" forKey:@"number"];
    self.addressPropertiesDictionary = addressProperties;
    
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressStreet = [self.addressPropertiesDictionary objectForKey:@"street"];
    NSString *addressComplement = [self.addressPropertiesDictionary objectForKey:@"complement"];

    NSString *decodeStreetNameStrint = [addressStreet kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutNumber = [NSString stringWithFormat:@"%@, S/N - %@", decodeStreetNameStrint, addressComplement];
    
    NSString *resultString = [self.shipAddressCell streetLabelContentWithName:addressStreet withNumber:@"" withComplement:addressComplement];
    XCTAssertTrue([expectedStringWithoutNumber isEqualToString:resultString]);
}

- (void)testStreetNameWithComplementWithoutComplement {
    
    NSMutableDictionary *addressProperties = [[NSMutableDictionary alloc] initWithDictionary:self.addressPropertiesDictionary];
    [addressProperties setObject:@"" forKey:@"complement"];
    self.addressPropertiesDictionary = addressProperties;
    
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressStreet = [self.addressPropertiesDictionary objectForKey:@"street"];
    NSString *addressNumber = [self.addressPropertiesDictionary objectForKey:@"number"];
    
    NSString *decodeStreetNameStrint = [addressStreet kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutComplement = [NSString stringWithFormat:@"%@, %@", decodeStreetNameStrint, addressNumber];
    
    NSString *resultString = [self.shipAddressCell streetLabelContentWithName:addressStreet withNumber:addressNumber withComplement:@""];
    XCTAssertTrue([expectedStringWithoutComplement isEqualToString:resultString]);
}

- (void)testStreetNameWithComplementWithoutComplementAndNumber {
    
    NSMutableDictionary *addressProperties = [[NSMutableDictionary alloc] initWithDictionary:self.addressPropertiesDictionary];
    [addressProperties setObject:@"" forKey:@"complement"];
    [addressProperties setObject:@"" forKey:@"number"];
    self.addressPropertiesDictionary = addressProperties;
    
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressStreet = [self.addressPropertiesDictionary objectForKey:@"street"];
    
    NSString *decodeStreetNameStrint = [addressStreet kv_decodeHTMLCharacterEntities];
    NSString *expectedStringWithoutComplement = [NSString stringWithFormat:@"%@, S/N", decodeStreetNameStrint];
    NSString *resultString = [self.shipAddressCell streetLabelContentWithName:addressStreet withNumber:@"" withComplement:@""];
    XCTAssertTrue([expectedStringWithoutComplement isEqualToString:resultString]);
}

- (void)testAdditionalInformationSuccess {
    
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressNeighborhood = [self.addressPropertiesDictionary objectForKey:@"neighborhood"];
    NSString *addressCity = [self.addressPropertiesDictionary objectForKey:@"city"];
    NSString *addressState = [self.addressPropertiesDictionary objectForKey:@"state"];
    
    NSString *expectedString = [NSString stringWithFormat:@"%@ - %@ - %@", addressNeighborhood, addressCity, addressState];
    
    NSString *resultString = [self.shipAddressCell additionalInformationWithNeighborhood:addressNeighborhood withCity:addressCity withState:addressState];
    
    XCTAssertTrue([expectedString isEqualToString:resultString]);
}

- (void)testFormatZipcodeString {
    
    [self.shipAddressCell setupWithAddressDict:self.addressPropertiesDictionary enableEditControls:TRUE];
    
    NSString *addressZipcode = [self.addressPropertiesDictionary objectForKey:@"postalCode"];
    NSMutableString *expectedString = [NSMutableString stringWithString:addressZipcode];
    [expectedString insertString:@"-" atIndex:zipcodeDashIndex];
    
    NSString *resultString = [self.shipAddressCell formatZipcodeString:addressZipcode];
    
    XCTAssertTrue([expectedString isEqualToString:resultString]);
}

@end
