//
//  ResetPasswordViewTests.m
//  Walmart
//
//  Created by Renan Cargnin on 3/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ResetPasswordView.h"

@interface ResetPasswordView ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet WMButton *sendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterYConstraint;

- (void)prepareForRecoverPasswordRequest;
- (void)resetPasswordWithEmail:(NSString *)email;
- (void)resetPasswordWithDocument:(NSString *)document;
- (void)resetPasswordError:(NSError *)error;
- (IBAction)pressedSendButton;

@end

@interface ResetPasswordViewTests : XCTestCase

@property (strong, nonatomic) ResetPasswordView *view;

@end

@implementation ResetPasswordViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.view = [ResetPasswordView new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPreRequestSetup {
    [_view prepareForRecoverPasswordRequest];
    
    XCTAssertFalse(_view.sendButton.enabled);
    XCTAssertTrue(_view.activityIndicator.isAnimating);
    XCTAssertFalse(_view.emailTextField.isFirstResponder);
}

- (void)testResetPasswordWithEmail {
    [_view resetPasswordWithEmail:@"teste@teste.com.br"];
    [self testPreRequestSetup];
}

- (void)testResetPasswordWithDocument {
    [_view resetPasswordWithDocument:@"11111111111"];
    [self testPreRequestSetup];
}

- (void)testResetPasswordError {
    [_view resetPasswordError:nil];
    
    XCTAssertTrue(_view.sendButton.enabled);
    XCTAssertFalse(_view.activityIndicator.isAnimating);
}

- (void)testPressedSendButton {
    [_view pressedSendButton];
    
    XCTAssertFalse(_view.emailTextField.isFirstResponder);
}

@end
