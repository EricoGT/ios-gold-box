//
//  UIView+Alert.m
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIView+Alert.h"

#import "WMAlertView.h"
#import "WMPopupView.h"
#import "DeletePopupView.h"
#import "WMRetryAlertView.h"

@implementation UIView (Alert)

#pragma mark - WMAlertView
- (void)showAlertWithBackgroundColor:(UIColor *)backgroundColor iconImageName:(NSString *)iconImageName title:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock {
    WMAlertView *alertView = [[WMAlertView alloc] initWithImageName:iconImageName title:title message:message dismissButtonText:dismissButtonTitle dismissBlock:dismissBlock];
    alertView.backgroundColor = backgroundColor;
    [self addSubview:alertView];
}

- (void)showAlertWithImageName:(NSString *)imageName title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock {
    WMAlertView *alertView = [[WMAlertView alloc] initWithImageName:imageName title:title attributedMessage:attributedMessage dismissButtonText:dismissButtonTitle dismissBlock:dismissBlock];
    [self addSubview:alertView];
}

- (void)showAlertWithImageName:(NSString *)imageName title:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock {
    [self showAlertWithBackgroundColor:RGBA(33, 150, 243, 0.7f) iconImageName:imageName title:title message:message dismissButtonTitle:dismissButtonTitle dismissBlock:dismissBlock];
}

- (void)showAlertWithImageName:(NSString *)imageName message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock {
    [self showAlertWithImageName:imageName title:GREETING_OPS message:message dismissButtonTitle:dismissButtonTitle dismissBlock:dismissBlock];
}

- (void)showAlertWithImageName:(NSString *)imageName message:(NSString *)message dismissBlock:(void (^)())dismissBlock {
    [self showAlertWithImageName:imageName message:message dismissButtonTitle:@"OK" dismissBlock:dismissBlock];
}

- (void)showAlertWithMessage:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock {
    [self showAlertWithImageName:nil message:message dismissButtonTitle:dismissButtonTitle dismissBlock:dismissBlock];
}

- (void)showAlertWithMessage:(NSString *)message dismissBlock:(void (^)())dismissBlock {
    [self showAlertWithImageName:nil message:message dismissBlock:dismissBlock];
}

- (void)showAlertWithMessage:(NSString *)message {
    [self showAlertWithMessage:message dismissBlock:nil];
}

#pragma mark - WMPopupView
- (void)showPopupWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(void (^)())cancelBlock actionButtonTitle:(NSString *)actionButtonTitle actionBlock:(void (^)())actionBlock
{
    WMPopupView *popupView = [[WMPopupView alloc] initWithTitle:title
                                                        message:message
                                              cancelButtonTitle:cancelButtonTitle
                                                    cancelBlock:cancelBlock
                                              actionButtonTitle:actionButtonTitle
                                                    actionBlock:actionBlock];
    [self addSubview:popupView];
}

#pragma mark - Retry Alert
- (void)showRetryAlertWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock cancelBlock:(void (^)())cancelBlock
{
    WMRetryAlertView *retryAlert = [[WMRetryAlertView alloc] initWithTitle:GREETING_OPS message:message retryBlock:retryBlock cancelBlock:cancelBlock];
    [self addSubview:retryAlert];
}

- (void)showRetryAlertWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock
{
    [self showRetryAlertWithMessage:message retryBlock:retryBlock cancelBlock:nil];
}

#pragma mark - DeletePopupView
- (void)showDeletePopupWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock deleteBlock:(void (^)())deleteBlock {
    DeletePopupView *deletePopup = [[DeletePopupView alloc] initWithTitle:title message:message cancelBlock:cancelBlock deleteBlock:deleteBlock];
    [self addSubview:deletePopup];
}

#pragma mark - FormAlert
- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message
{
    [self showFeedbackAlertOfKind:kind message:message easeInCompletion:nil easeOutCompletion:nil];
}

- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message easeInCompletion:(void (^)())easeInCompletionBlock easeOutCompletion:(void (^)())easeOutCompletionBlock
{
    FeedbackAlertView *feedbackAlert = [[FeedbackAlertView alloc] initWithFeedbackAlertKind:kind message:message];
    [self addSubview:feedbackAlert];
    [feedbackAlert animateWithEaseInCompletionBlock:easeInCompletionBlock easeOutCompletionBlock:easeOutCompletionBlock];
    
     [self performSelector:@selector(removeAlertForced:) withObject:feedbackAlert afterDelay:5];
}

- (void)showFaceFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message
{
    [self showFaceFeedbackAlertOfKind:kind message:message easeInCompletion:nil easeOutCompletion:nil];
}

- (void)showFaceFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message easeInCompletion:(void (^)())easeInCompletionBlock easeOutCompletion:(void (^)())easeOutCompletionBlock
{
    FeedbackAlertView *feedbackAlert = [[FeedbackAlertView alloc] initWithFeedbackAlertKind:kind message:message];
    [self addSubview:feedbackAlert];
    [feedbackAlert animateWithEaseInCompletionBlock:easeInCompletionBlock easeOutCompletionBlock:easeOutCompletionBlock];
    
    [self performSelector:@selector(removeAlertForced:) withObject:feedbackAlert afterDelay:5];
}

- (void) removeAlertForced:(FeedbackAlertView *) alert {
    
    [alert removeFromSuperview];
}

- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind title:(NSString *)title message:(NSString *)message {
    FeedbackAlertView *feedbackAlert = [[FeedbackAlertView alloc] initWithTitle:title message:message];
    [feedbackAlert setKind:kind];
    [self addSubview:feedbackAlert];
    [feedbackAlert animateWithEaseInCompletionBlock:nil easeOutCompletionBlock:nil];
}

- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage {
    FeedbackAlertView *feedbackAlert = [[FeedbackAlertView alloc] initWithTitle:title attributedMessage:attributedMessage];
    [feedbackAlert setKind:kind];
    [self addSubview:feedbackAlert];
    [feedbackAlert animateWithEaseInCompletionBlock:nil easeOutCompletionBlock:nil];
}

@end
