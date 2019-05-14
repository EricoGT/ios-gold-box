//
//  UIView+Alert.h
//  Walmart
//
//  Created by Renan Cargnin on 3/3/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedbackAlertView.h"

@interface UIView (Alert)

#pragma mark - WMAlertView
/**
 *  Shows default alert (only one button)
 *
 *  @param kind NSString imageName with the name of the image to be displayed in the alert
 *  @param kind NSString message with the message to be displayed in the alert
 *  @param kind Block dismissBlock with the block that should be executed once the alert is dismissed
 */
- (void)showAlertWithBackgroundColor:(UIColor *)backgroundColor iconImageName:(NSString *)iconImageName title:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithImageName:(NSString *)imageName title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithImageName:(NSString *)imageName title:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithImageName:(NSString *)imageName message:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithImageName:(NSString *)imageName message:(NSString *)message dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithMessage:(NSString *)message dismissButtonTitle:(NSString *)dismissButtonTitle dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithMessage:(NSString *)message dismissBlock:(void (^)())dismissBlock;
- (void)showAlertWithMessage:(NSString *)message;

#pragma mark - WMPopupView
/**
 *  Shows popup alert (two buttons)
 *
 *  @param kind NSString title with the title to be displayed in the alert
 *  @param kind NSString message with the message to be displayed in the alert
 *  @param kind NSString cancelButtonTitle with the title to be displayed in the cancel button
 *  @param kind NSString actionButtonTitle with the title to be displayed in the action button
 *  @param kind Block cancelBlock with the block that should be executed once the user presses the cancel button
 *  @param kind Block actionBlock with the block that should be executed once the user presses the action button
 */
- (void)showPopupWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(void (^)())cancelBlock actionButtonTitle:(NSString *)actionButtonTitle actionBlock:(void (^)())actionBlock;

#pragma mark - WMRetryAlertView
/**
 *  Shows popup alert (two buttons)
 *
 *  @param kind NSString message with the message to be displayed in the alert
 *  @param kind Block cancelBlock with the block that should be executed once the user presses the cancel button
 *  @param kind Block actionBlock with the block that should be executed once the user presses the retry button
 */
- (void)showRetryAlertWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock cancelBlock:(void (^)())cancelBlock;
- (void)showRetryAlertWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock;

#pragma mark - DeletePopupView
/**
 *  Shows alert for deletions
 *
 *  @param kind NSString title with the title to be displayed in the alert
 *  @param kind NSString message with the message to be displayed in the alert
 *  @param kind Block cancelBlock with the block that should be executed once the user cancels the action
 *  @param kind Block cancelBlock with the block that should be executed once the user confirms the action
 */
- (void)showDeletePopupWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock deleteBlock:(void (^)())deleteBlock;

#pragma mark - FormAlertView
/**
 *  Shows feedback alert (Simple alert from bottom)
 *
 *  @param kind Enum Kind of the alert, can be ErrorAlert, WarningAlert or SuccessAlert
 *  @param kind NSString with the message to be displayed in the alert
 *  @param easeInCompletionBlock Block with the code to be executed when the ease in animation finished
 *  @param easeOutCompletionBlock Block with the code to be executed when the ease out animation finished
 */
- (void)showFaceFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;
- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;
- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message easeInCompletion:(void (^)())easeInCompletionBlock easeOutCompletion:(void (^)())easeOutCompletionBlock;
- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind title:(NSString *)title message:(NSString *)message;
- (void)showFeedbackAlertOfKind:(FeedbackAlertKind)kind title:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage;

@end
