//
//  AddressesListTests.m
//  Walmart
//
//  Created by Renan on 5/22/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AddressModel.h"
#import "MyAddressesTableViewController.h"

@interface AddressesListTests : XCTestCase {
    NSArray *addresses;
    MyAddressesTableViewController *myAddressesTVC;
}

@end

@implementation AddressesListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    myAddressesTVC = [[MyAddressesTableViewController alloc] initWithNibName:@"MyAddressesTableViewController" bundle:nil];
    [myAddressesTVC tableView];
    
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
    
    NSError *parseError;
    AddressModel *address = [[AddressModel alloc] initWithDictionary:addressDict error:&parseError];
    XCTAssertNil(parseError);
    
    AddressModel *address2 = address.copy;
    address2.addressId = @"2";
    address2.defaultAddress = @YES;
    
    AddressModel *address3 = address.copy;
    address3.addressId = @"3";
    
    AddressModel *address4 = address.copy;
    address4.addressId = @"4";
    
    AddressModel *address5 = address.copy;
    address5.addressId = @"5";
    
    myAddressesTVC.addresses = @[address.copy, address2, address3, address4, address5];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddressesOrder {
    NSArray *initialAddresses = myAddressesTVC.addresses.copy;
    
    myAddressesTVC.addresses = [myAddressesTVC reorderedAddresses:initialAddresses];
    AddressModel *firstAddress = myAddressesTVC.addresses.firstObject;
    XCTAssertTrue(firstAddress.defaultAddress, @"The default address is the first of the list.");
    
    for (AddressModel *address in initialAddresses) {
        address.defaultAddress = @NO;
    }
    myAddressesTVC.addresses = [myAddressesTVC reorderedAddresses:initialAddresses];
    firstAddress = myAddressesTVC.addresses.firstObject;
    XCTAssertTrue([firstAddress.addressId isEqualToString:((AddressModel *)initialAddresses.lastObject).addressId], @"The list has no default address, but the most recent address is the first of the list.");
}

@end
