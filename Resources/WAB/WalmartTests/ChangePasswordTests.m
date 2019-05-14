//
//  ChangePasswordTests.m
//  Walmart
//
//  Created by Renan on 5/8/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ChangePasswordViewController.h"
#import "WMFloatLabelMaskedTextField.h"
#import "OFMessages.h"

@interface ChangePasswordTests : XCTestCase {
    NSString *validPassword;
    NSString *invalidPassword;
}

@property (strong, nonatomic) ChangePasswordViewController *vc;

@end

@implementation ChangePasswordTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    validPassword = @"12345678";
    invalidPassword = @"1234";
    
    self.vc = [ChangePasswordViewController new];
    [_vc view];
}

- (void)testCurrentPasswordEmpty {
    _vc.txtCurrentPass.text = @"";
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:_vc.txtCurrentPass]);
}

- (void)testNewPasswordEmpty {
    _vc.txtCurrentPass.text = validPassword;
    _vc.txtNewPass.text = @"";
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:_vc.txtNewPass]);
}

- (void)testNewPasswordConfirmationEmpty {
    _vc.txtCurrentPass.text = validPassword;
    _vc.txtNewPass.text = validPassword;
    _vc.txtNewPassConfirmation.text = @"";
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:_vc.txtNewPassConfirmation]);
}

- (void)testNewPasswordMinLength {
    _vc.txtCurrentPass.text = validPassword;
    _vc.txtNewPass.text = invalidPassword;
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:_vc.txtNewPass]);
}

- (void)testNewPasswordsMatch {
    _vc.txtCurrentPass.text = validPassword;
    _vc.txtNewPass.text = validPassword;
    _vc.txtNewPassConfirmation.text = [_vc.txtNewPass.text stringByAppendingString:@"a"];
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue([invalidFields containsObject:_vc.txtNewPassConfirmation]);
}

- (void)testChangePasswordSuccess {
    _vc.txtCurrentPass.text = validPassword;
    _vc.txtNewPass.text = validPassword;
    _vc.txtNewPassConfirmation.text = validPassword;
    NSArray *invalidFields = [_vc validateAndGetInvalidFields];
    XCTAssertTrue(invalidFields.count == 0);
}

@end
