//
//  UIView+AlertTests.m
//  Walmart
//
//  Created by Renan on 6/9/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WMAlertView.h"
#import "WMPopupView.h"
#import "WMRetryAlertView.h"
#import "DeletePopupView.h"

@interface UIView (Test)

- (void) removeAlertForced:(FeedbackAlertView *) alert;
- (void)showFaceFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message easeInCompletion:(void (^)())easeInCompletionBlock easeOutCompletion:(void (^)())easeOutCompletionBlock;

@end

@interface UIView_AlertTests : XCTestCase

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *message;
@property (copy, nonatomic) void (^dismissBlock)();
@property (strong, nonatomic) NSString *dismissButtonTitle;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSString *actionButtonTitle;

@property (copy, nonatomic) void (^cancelBlock)();
@property (copy, nonatomic) void (^actionBlock)();

@property (copy, nonatomic) void (^retryBlock)();

@property (copy, nonatomic) void (^deleteBlock)();

@property (assign, nonatomic) FeedbackAlertKind feedbackAlertKind;
@property (copy, nonatomic) void (^easeInCompletionBlock)();
@property (copy, nonatomic) void (^easeOutCompletionBlock)();

@end

@implementation UIView_AlertTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.view = [UIView new];
    
    self.message = @"Test message";
    
    self.dismissBlock = ^(){
        LogInfo(@"Test");
    };
    
    self.dismissButtonTitle = @"Test dismiss button title";
    self.imageName = @"ico_success";
    self.title = @"Test title";
    
    self.cancelButtonTitle = @"Test cancel button title";
    self.actionButtonTitle = @"Test action button title";
    self.actionBlock = ^(){
        LogInfo(@"Action Block");
    };
    self.cancelBlock = ^(){
        LogInfo(@"Cancel Block");
    };
    
    self.retryBlock = ^(){
        LogInfo(@"Retry Block");
    };
    
    self.deleteBlock = ^(){
        LogInfo(@"Delete Block");
    };
    
    self.feedbackAlertKind = SuccessAlert;
    self.easeInCompletionBlock = ^(){
        LogInfo(@"Ease In Completion Block");
    };
    self.easeOutCompletionBlock = ^(){
        LogInfo(@"Ease Out Completion Block");
    };
}

#pragma mark - Alert
- (void)testShowAlertWithMessage {
    [_view showAlertWithMessage:_message];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.messageLabel.text, _message);
}

- (void)testShowAlertWithDismissBlock {
    [_view showAlertWithMessage:_message dismissBlock:_dismissBlock];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.messageLabel.text, _message);
    XCTAssertEqualObjects(alertView.dismissBlock, _dismissBlock);
}

- (void)testShowAlertWithDismissButtonTitle {
    [_view showAlertWithMessage:_message dismissButtonTitle:_dismissButtonTitle dismissBlock:_dismissBlock];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.messageLabel.text, _message);
    XCTAssertEqualObjects(alertView.dismissBlock, _dismissBlock);
    XCTAssertEqualObjects([alertView.dismissButton titleForState:UIControlStateNormal], _dismissButtonTitle);
}

- (void)testShowAlertWithImage {
    [_view showAlertWithImageName:_imageName message:_message dismissBlock:_dismissBlock];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.messageLabel.text, _message);
    XCTAssertEqualObjects(alertView.dismissBlock, _dismissBlock);
    XCTAssertEqualObjects(alertView.imageView.image, [UIImage imageNamed:_imageName]);
}

- (void)testShowAlertWithTitle {
    [_view showAlertWithImageName:_imageName title:_title message:_message dismissButtonTitle:_dismissButtonTitle dismissBlock:_dismissBlock];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.messageLabel.text, _message);
    XCTAssertEqualObjects(alertView.dismissBlock, _dismissBlock);
    XCTAssertEqualObjects(alertView.imageView.image, [UIImage imageNamed:_imageName]);
    XCTAssertEqualObjects(alertView.titleLabel.text, _title);
}

- (void)testShowAlertWithAttributedMessage {
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:_message];
    [_view showAlertWithImageName:_imageName title:_title attributedMessage:attributedMessage dismissButtonTitle:_dismissButtonTitle dismissBlock:_dismissBlock];
    
    WMAlertView *alertView = _view.subviews.lastObject;
    XCTAssertNotNil(alertView);
    
    XCTAssertEqualObjects(alertView.imageView.image, [UIImage imageNamed:_imageName]);
    XCTAssertEqualObjects(alertView.titleLabel.text, _title);
    XCTAssertEqualObjects(alertView.messageLabel.attributedText, attributedMessage);
    XCTAssertEqualObjects([alertView.dismissButton titleForState:UIControlStateNormal], _dismissButtonTitle);
    XCTAssertEqualObjects(alertView.dismissBlock, _dismissBlock);
}

#pragma mark - Popup
- (void)testShowPopup {
    [_view showPopupWithTitle:_title message:_message cancelButtonTitle:_cancelButtonTitle cancelBlock:_cancelBlock actionButtonTitle:_actionButtonTitle actionBlock:_actionBlock];
    
    WMPopupView *popupView = _view.subviews.lastObject;
    XCTAssertTrue([popupView isKindOfClass:[WMPopupView class]]);
    XCTAssertEqual(popupView.superview, _view);
    
    XCTAssertEqualObjects(popupView.titleLabel.text, _title);
    XCTAssertEqualObjects(popupView.messageLabel.text, _message);
    XCTAssertEqualObjects([popupView.cancelButton titleForState:UIControlStateNormal], _cancelButtonTitle);
    XCTAssertEqualObjects([popupView.actionButton titleForState:UIControlStateNormal], _actionButtonTitle);
    XCTAssertEqualObjects(popupView.cancelBlock, _cancelBlock);
    XCTAssertEqualObjects(popupView.actionBlock, _actionBlock);
}

#pragma mark - Retry Alert
- (void)testShowRetryAlert {
    [_view showRetryAlertWithMessage:_message retryBlock:_retryBlock];
    
    WMRetryAlertView *retryAlertView = _view.subviews.lastObject;
    XCTAssertTrue([retryAlertView isKindOfClass:[WMRetryAlertView class]]);
    XCTAssertEqual(retryAlertView.superview, _view);
    
    XCTAssertEqualObjects(retryAlertView.messageLabel.text, _message);
    XCTAssertEqualObjects(retryAlertView.retryBlock, _retryBlock);
}

- (void)testShowRetryAlertWithCancelBlock {
    [_view showRetryAlertWithMessage:_message retryBlock:_retryBlock cancelBlock:_cancelBlock];
    
    WMRetryAlertView *retryAlertView = _view.subviews.lastObject;
    XCTAssertTrue([retryAlertView isKindOfClass:[WMRetryAlertView class]]);
    XCTAssertEqual(retryAlertView.superview, _view);
    
    XCTAssertEqualObjects(retryAlertView.messageLabel.text, _message);
    XCTAssertEqualObjects(retryAlertView.retryBlock, _retryBlock);
    XCTAssertEqualObjects(retryAlertView.cancelBlock, _cancelBlock);
}

#pragma mark - Delete Popup
- (void)testShowDeletePopup {
    [_view showDeletePopupWithTitle:_title message:_message cancelBlock:_cancelBlock deleteBlock:_deleteBlock];
    
    DeletePopupView *deletePopupView = _view.subviews.lastObject;
    XCTAssertTrue([deletePopupView isKindOfClass:[DeletePopupView class]]);
    XCTAssertEqual(deletePopupView.superview, _view);
    
    XCTAssertEqualObjects(deletePopupView.titleLabel.text, _title);
    XCTAssertEqualObjects(deletePopupView.messageLabel.text, _message);
    XCTAssertEqualObjects(deletePopupView.cancelBlock, _cancelBlock);
    XCTAssertEqualObjects(deletePopupView.deleteBlock, _deleteBlock);
}

#pragma mark - Feedback Alert
- (void)testShowFeedbackAlert {
    [self.view showFeedbackAlertOfKind:self.feedbackAlertKind message:self.message];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
    
    XCTAssertEqualObjects(feedbackAlertView.lbMessage.text, self.message);
}

- (void)testShowFeedbackAlertWithTitle {
    [self.view showFeedbackAlertOfKind:self.feedbackAlertKind title:_title message:self.message];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
}

- (void)testShowFeedbackAlertWithAttributedMessage {
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:self.message];
    [self.view showFeedbackAlertOfKind:self.feedbackAlertKind title:self.title attributedMessage:attributedMessage];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
}

- (void)testShowFeedbackAlertWithCompletionBlocks {
    [self.view showFeedbackAlertOfKind:self.feedbackAlertKind message:self.message easeInCompletion:self.easeInCompletionBlock easeOutCompletion:self.easeOutCompletionBlock];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
}

- (void)testRemoveAlertForced {
    [self.view showFeedbackAlertOfKind:self.feedbackAlertKind message:self.message];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
    
    [self.view removeAlertForced:feedbackAlertView];
    XCTAssertFalse([self.view.subviews.lastObject isKindOfClass:[FeedbackAlertView class]]);
}

- (void)testShowFaceFeedbackAlertOfKindAndMessage {
    [self.view showFaceFeedbackAlertOfKind:self.feedbackAlertKind message:self.message];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
}

- (void)testShowFaceFeedbackAlertOfKindAndMessageAndEaseInCompletion {
    
    [self.view showFaceFeedbackAlertOfKind:self.feedbackAlertKind message:self.message easeInCompletion:self.easeInCompletionBlock easeOutCompletion:self.easeOutCompletionBlock];
    
    FeedbackAlertView *feedbackAlertView = self.view.subviews.lastObject;
    XCTAssertTrue([feedbackAlertView isKindOfClass:[FeedbackAlertView class]]);
    XCTAssertEqual(feedbackAlertView.superview, self.view);
}

@end
