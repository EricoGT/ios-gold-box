//
//  FormAlertView.h
//  Walmart
//
//  Created by Renan on 4/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

typedef enum {
    ErrorAlert = 0,
    WarningAlert = 1,
    SuccessAlert = 2,
} FeedbackAlertKind;

@interface FeedbackAlertView : WMView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;

@property (assign, nonatomic) FeedbackAlertKind kind;

+ (UIColor *)colorForFeedbackAlertKind:(FeedbackAlertKind)formAlertKind;

//Temporary
- (FeedbackAlertView *)initWithFeedbackAlertKind:(FeedbackAlertKind)formAlertKind message:(NSString *)message;
- (FeedbackAlertView *)initWithTitle:(NSString *)title message:(NSString *)message;
- (FeedbackAlertView *)initWithTitle:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage;

- (void)animateWithEaseInCompletionBlock:(void (^)())easeInFinished easeOutCompletionBlock:(void (^)())easeOutFinished;
- (void)animateWithEaseDuration:(CGFloat)easeDuration easeOutDelay:(CGFloat)easeOutDelay easeInnCompletionBlock:(void (^)())easeInFinished easeOutCompletionBlock:(void (^)())easeOutFinished;

@end
