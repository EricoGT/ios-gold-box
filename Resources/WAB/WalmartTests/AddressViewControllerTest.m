//
//  AddressViewControllerTest.m
//  Walmart
//
//  Created by Bruno Delgado on 5/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AddressModel.h"
#import "AddressViewController.h"

@interface AddressViewControllerTest : XCTestCase
{
    AddressModel *address;
    AddressViewController *controller;
}

@end

@interface AddressViewController (Test)

@property (nonatomic, weak) IBOutlet UIButton *mainAdressCheckmarkButton;
@property (nonatomic, assign) BOOL mainAddress;

@end

@implementation AddressViewControllerTest

- (void)setUp
{
    [super setUp];
    
    address = [AddressModel new];
    address.addressId = @"1";
    address.receiverName = @"Bruno Delgado";
    address.type = @"Comercial";
    address.street = @"Rua Cauré";
    address.number = @"65";
    address.complement = @"Casa";
    address.neighborhood = @"Vila Mazzei";
    address.city = @"São Paulo";
    address.state = @"SP";
    address.zipcode = @"02310140";
    address.referencePoint = @"Paralela com a Avenida Mazzei";
    address.defaultAddress = @YES;
    
    controller = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
    [controller view];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testInvalidName
{
    address.receiverName = @"Bruno";
    [controller updateAddressWithModel:address];
    
    NSArray *invalidFields = [controller validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:controller.receiverNameTextField]);
    XCTAssertTrue([controller.alertMsg isEqualToString:ADDRESS_WARNING_NAME]);
}

- (void)testDefaultAddress
{
    address.defaultAddress = @NO;
    controller.mainAddress = NO;
    XCTAssertEqualObjects(controller.mainAdressCheckmarkButton.imageView.image, [UIImage imageNamed:@"btn_checkbox_off.png"]);
    
    address.defaultAddress = @YES;
    controller.mainAddress = YES;
    XCTAssertEqualObjects(controller.mainAdressCheckmarkButton.imageView.image, [UIImage imageNamed:@"btn_checkbox_on.png"]);
}

- (void)testNavigationTitleAccordingToAction
{
    controller.editingAddress = NO;
    [controller setUp];
    XCTAssertTrue([controller.title isEqualToString:MY_ADDRESSES_NEW_ADDRESS_TITLE]);
    
    controller.editingAddress = YES;
    [controller setUp];
    XCTAssertTrue([controller.title isEqualToString:MY_ADDRESSES_EDIT_ADDRESS_TITLE]);
}

@end
