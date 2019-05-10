//
//  ExtendedWarrantyDetailTest.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ExtendedWarrantyDetailViewController.h"
#import "ExtendedWarrantyDetail.h"
#import "AddressModel.h"
#import "ExtendedWarrantyOptionsCell.h"
#import "ExtendedWarrantyBuilder.h"

@interface ExtendedWarrantyDetailTest : XCTestCase
{
    ExtendedWarrantyDetailViewController *controller;
    ExtendedWarrantyDetail *warranty;
}

@end

@implementation ExtendedWarrantyDetailTest



- (void)setUp
{
    [super setUp];
    
    controller = [[ExtendedWarrantyDetailViewController alloc] initWithNibName:@"ExtendedWarrantyDetailViewController" bundle:nil];
    [controller view];
    warranty = [ExtendedWarrantyBuilder baseWarrantyDetail];
    controller.warranty = warranty;
}

- (void)testNormalState
{
    warranty.cancelled = @(NO);
    warranty.cancelable = @(YES);
    
    [controller setWarrantyState];
    [controller setupInterfaceForExtendedWarranty];
    
    XCTAssertTrue([controller.tableView numberOfRowsInSection:0] == 3);
    XCTAssertNil(controller.tableView.tableFooterView);
    XCTAssertEqualObjects(controller.enrollmentDateTitle.text, EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE);
    XCTAssertEqualObjects(controller.startDateTitle.text, EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE);
    
    ExtendedWarrantyOptionsCell *cell1 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ExtendedWarrantyOptionsCell *cell2 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ExtendedWarrantyOptionsCell *cell3 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    XCTAssertEqualObjects(cell1.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_SEE_TICKET);
    XCTAssertEqualObjects(cell1.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
    
    XCTAssertEqualObjects(cell2.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_AUTORIZATION);
    XCTAssertEqualObjects(cell2.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
    
    XCTAssertEqualObjects(cell3.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_CANCEL);
    XCTAssertEqualObjects(cell3.optionImageView.image, [UIImage imageNamed:@"ico_cancel.png"]);
}

- (void)testCancellingState
{
    controller.warranty.state = @(WarrantyStateCancelling);
    [controller setupInterfaceForExtendedWarranty];
    
    XCTAssertTrue([controller.tableView numberOfRowsInSection:0] == 2);
    XCTAssertNotNil(controller.tableView.tableFooterView);
    
    ExtendedWarrantyOptionsCell *cell1 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ExtendedWarrantyOptionsCell *cell2 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    XCTAssertEqualObjects(cell1.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_SEE_TICKET);
    XCTAssertEqualObjects(cell1.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
    
    XCTAssertEqualObjects(cell2.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_AUTORIZATION);
    XCTAssertEqualObjects(cell2.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
}

- (void)testCancelledState
{
    warranty.cancelled = @(YES);
    
    [controller setWarrantyState];
    [controller setupInterfaceForExtendedWarranty];
    
    XCTAssertTrue([controller.tableView numberOfRowsInSection:0] == 3);
    XCTAssertNil(controller.tableView.tableFooterView);
    XCTAssertTrue([controller.enrollmentDateTitle.text isEqualToString:EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE]);
    XCTAssertEqualObjects(controller.startDateTitle.text, EXTENDED_WARRANTY_DETAIL_CANCEL_TITLE);
    
    ExtendedWarrantyOptionsCell *cell1 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ExtendedWarrantyOptionsCell *cell2 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ExtendedWarrantyOptionsCell *cell3 = (ExtendedWarrantyOptionsCell *)[controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    XCTAssertEqualObjects(cell1.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_SEE_TICKET);
    XCTAssertEqualObjects(cell1.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
    
    XCTAssertEqualObjects(cell2.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_AUTORIZATION);
    XCTAssertEqualObjects(cell2.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
    
    XCTAssertEqualObjects(cell3.optionNameLabel.text, EXTENDED_WARRANTY_DETAIL_OPTION_CANCELLED);
    XCTAssertEqualObjects(cell3.optionImageView.image, [UIImage imageNamed:@"ico_pdf.png"]);
}

- (void)testCancellableOption
{
    warranty.cancelled = @(NO);
    warranty.cancelable = @(YES);
    
    [controller setWarrantyState];
    [controller setupInterfaceForExtendedWarranty];
    XCTAssertTrue([controller.tableView numberOfRowsInSection:0] == 3);
    XCTAssertNil(controller.tableView.tableFooterView);
    XCTAssertNil(controller.tableView.tableFooterView);
    
    warranty.cancelable = @(NO);
    [controller setWarrantyState];
    [controller setupInterfaceForExtendedWarranty];
    
    XCTAssertTrue([controller.tableView numberOfRowsInSection:0] == 3);
    XCTAssertNil(controller.tableView.tableFooterView);
    XCTAssertTrue([controller.enrollmentDateTitle.text isEqualToString:EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE]);
    XCTAssertEqualObjects(controller.startDateTitle.text, EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE);
}

- (void)tearDown
{
    [super tearDown];
    controller = nil;
    warranty = nil;
}

@end
