//
//  TestCancelExtendedWarranty.m
//  Walmart
//
//  Created by Bruno on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CancelWarrantyViewController.h"
#import "ExtendedWarrantyBuilder.h"
#import "NSDate+DateTools.h"
#import "WMPickerTextField.h"
#import "WMButton.h"

@interface TestCancelExtendedWarranty : XCTestCase
{
    CancelWarrantyViewController *controller;
    ExtendedWarrantyDetail *warranty;
}

@end

@implementation TestCancelExtendedWarranty

- (void)setUp
{
    [super setUp];
    
    controller = [[CancelWarrantyViewController alloc] initWithNibName:@"CancelWarrantyViewController" bundle:nil];
    [controller view];
    
    warranty = [ExtendedWarrantyBuilder baseWarrantyDetail];
    controller.warranty = warranty;
    [controller fillExtendedWarrantyCard];
    [controller addObserver:controller forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)tearDown
{
    @try {[controller removeObserver:controller forKeyPath:@"state" context:nil];} @catch (NSException *exception) {}
    controller = nil;
    warranty = nil;
    [super tearDown];
}

- (void)testWarrantyCard
{
    XCTAssertNotNil(controller.warrantyNameLabel.text);
    XCTAssertEqualObjects(controller.enrollmentDateTitle.text, EXTENDED_WARRANTY_DETAIL_ENROLLMENT_TITLE);
    XCTAssertEqualObjects(controller.enrollmentDateLabel.text, [warranty.enrollmentDate formattedDateWithFormat:@"dd/MM/YYYY"]);
    
    XCTAssertEqualObjects(controller.startDateTitle.text, EXTENDED_WARRANTY_DETAIL_START_DATE_TITLE);
    NSString *dateBegin = warranty.startDate ? [warranty.startDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    NSString *dateEnd = warranty.expirationDate ? [warranty.expirationDate formattedDateWithFormat:@"dd/MM/YYYY"] : @" ";
    NSString *fullRange = [NSString stringWithFormat:@"%@ até %@", dateBegin, dateEnd];
    XCTAssertEqualObjects(controller.startDateLabel.text, fullRange);
}

- (void)testLoading
{
    [controller showLoading];
    
    XCTAssertTrue(controller.reasonTextField.hidden);
    XCTAssertTrue(controller.optionTextField.hidden);
    XCTAssertTrue(controller.bankAccountTextField.hidden);
    XCTAssertTrue(controller.bankNameTextField.hidden);
    XCTAssertTrue(controller.agencyTextField.hidden);
    XCTAssertTrue(controller.accountTextField.hidden);
    XCTAssertTrue(controller.documentTextField.hidden);
    XCTAssertTrue(controller.footerLabel.hidden);
    XCTAssertTrue(controller.sendButton.hidden);
    
    XCTAssertFalse(controller.loader.hidden);
    XCTAssertTrue(controller.loader.isAnimating);
    [controller hideLoading];
}

- (void)testStateInitial
{
    controller.state = FormStateInitial;
    
    XCTAssertTrue(controller.bankAccountTextField.hidden);
    XCTAssertTrue(controller.bankNameTextField.hidden);
    XCTAssertTrue(controller.agencyTextField.hidden);
    XCTAssertTrue(controller.accountTextField.hidden);
    XCTAssertTrue(controller.documentTextField.hidden);
    XCTAssertTrue(controller.footerLabel.hidden);
    
    XCTAssertFalse(controller.reasonTextField.hidden);
    XCTAssertFalse(controller.optionTextField.hidden);
    XCTAssertFalse(controller.sendButton.hidden);
}

- (void)testStateChoosingRefundPossibilities
{
    controller.state = FormStateChoosingRefundPossibilities;
    
    XCTAssertTrue(controller.bankNameTextField.hidden);
    XCTAssertTrue(controller.agencyTextField.hidden);
    XCTAssertTrue(controller.accountTextField.hidden);
    XCTAssertTrue(controller.documentTextField.hidden);
    XCTAssertTrue(controller.footerLabel.hidden);
    
    XCTAssertFalse(controller.reasonTextField.hidden);
    XCTAssertFalse(controller.optionTextField.hidden);
    XCTAssertFalse(controller.bankAccountTextField.hidden);
    XCTAssertFalse(controller.sendButton.hidden);
}

- (void)testStateBankRefund
{
    controller.state = FormStateBankRefund;
    
    XCTAssertTrue(controller.documentTextField.hidden);
    
    XCTAssertFalse(controller.reasonTextField.hidden);
    XCTAssertFalse(controller.optionTextField.hidden);
    XCTAssertFalse(controller.bankAccountTextField.hidden);
    XCTAssertFalse(controller.sendButton.hidden);
    XCTAssertFalse(controller.bankNameTextField.hidden);
    XCTAssertFalse(controller.agencyTextField.hidden);
    XCTAssertFalse(controller.accountTextField.hidden);
    XCTAssertFalse(controller.footerLabel.hidden);
}

- (void)testStateDocumentRefund
{
    controller.state = FormStateDocumentRefund;
    
    XCTAssertTrue(controller.bankNameTextField.hidden);
    XCTAssertTrue(controller.agencyTextField.hidden);
    XCTAssertTrue(controller.accountTextField.hidden);
    
    XCTAssertFalse(controller.reasonTextField.hidden);
    XCTAssertFalse(controller.optionTextField.hidden);
    XCTAssertFalse(controller.bankAccountTextField.hidden);
    XCTAssertFalse(controller.documentTextField.hidden);
    XCTAssertFalse(controller.footerLabel.hidden);

    XCTAssertFalse(controller.sendButton.hidden);
}

- (void)testEmptyFields
{
    NSArray *invalidFields;
    
    controller.state = FormStateInitial;
    invalidFields = [controller validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:controller.reasonTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.optionTextField]);
    
    controller.state = FormStateChoosingRefundPossibilities;
    invalidFields = [controller validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:controller.reasonTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.optionTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.bankAccountTextField]);
    
    controller.state = FormStateBankRefund;
    invalidFields = [controller validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:controller.reasonTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.optionTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.bankAccountTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.bankNameTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.accountTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.agencyTextField]);
    
    controller.state = FormStateDocumentRefund;
    invalidFields = [controller validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:controller.reasonTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.optionTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.bankAccountTextField]);
    XCTAssertTrue([invalidFields containsObject:controller.documentTextField]);
}

@end
