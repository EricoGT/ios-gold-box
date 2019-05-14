//
//  FormAlertView.m
//  Walmart
//
//  Created by Renan on 4/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "FeedbackAlertView.h"

#import "FeedbackColor.h"

@interface FeedbackAlertView ()

@property (strong, nonatomic) NSLayoutConstraint *animationConstraint;

@end

@implementation FeedbackAlertView

- (FeedbackAlertView *)initWithFeedbackAlertKind:(FeedbackAlertKind)formAlertKind message:(NSString *)message {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setKind:formAlertKind];
        self.lbMessage.text = message;
        
        [self layoutIfNeeded];
        [self layoutSubviews];
    }
    return self;
}

- (FeedbackAlertView *)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [self initWithFeedbackAlertKind:SuccessAlert message:message];
    if (self) {
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", title, message]];
        [attributedMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f] range:[attributedMessage.string rangeOfString:title]];
        [attributedMessage addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans" size:16.0f] range:[attributedMessage.string rangeOfString:message]];
        [attributedMessage addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:NSMakeRange(0, attributedMessage.string.length)];
        [self setAttributedMessage:attributedMessage.copy];
    }
    return self;
}

- (FeedbackAlertView *)initWithTitle:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage {
    self = [self initWithFeedbackAlertKind:SuccessAlert message:attributedMessage.string];
    if (self) {
        NSMutableAttributedString *attributedMessageMutable = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", title]];
        [attributedMessageMutable appendAttributedString:attributedMessage];
        [attributedMessageMutable addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Semibold" size:16.0f] range:[attributedMessageMutable.string rangeOfString:title]];
        [attributedMessageMutable addAttribute:NSForegroundColorAttributeName value:RGBA(255, 255, 255, 1) range:NSMakeRange(0, attributedMessageMutable.string.length)];
        [self setAttributedMessage:attributedMessageMutable.copy];
    }
    return self;
}

- (void)setKind:(FeedbackAlertKind)kind {
    _kind = kind;
    _imageView.image = [UIImage imageNamed:[self imageNameForFormAlertKind:kind]];
    self.backgroundColor = [FeedbackAlertView colorForFeedbackAlertKind:kind];
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    _lbMessage.attributedText = attributedMessage;
}

- (void)layoutSubviews {
    _lbMessage.preferredMaxLayoutWidth = _lbMessage.bounds.size.width;
    
    [super layoutSubviews];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview && !self.translatesAutoresizingMaskIntoConstraints) {
        self.animationConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:self.bounds.size.height];
        [self.superview addConstraint:_animationConstraint];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
    }
}

#pragma mark - Animation
- (void)animateWithEaseInCompletionBlock:(void (^)())easeInFinished easeOutCompletionBlock:(void (^)())easeOutFinished {
    [self animateWithEaseDuration:0.25f easeOutDelay:3.5f easeInnCompletionBlock:easeInFinished easeOutCompletionBlock:easeOutFinished];
}

- (void)animateWithEaseDuration:(CGFloat)easeDuration easeOutDelay:(CGFloat)easeOutDelay easeInnCompletionBlock:(void (^)())easeInFinished easeOutCompletionBlock:(void (^)())easeOutFinished {
    if (_animationConstraint) {
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:easeDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_animationConstraint.constant = 0.0f;
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                if (easeInFinished) easeInFinished();
                
                [self.superview layoutIfNeeded];
                [UIView animateWithDuration:easeDuration delay:easeOutDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self->_animationConstraint.constant = self.bounds.size.height;
                    [self.superview layoutIfNeeded];
                } completion:^(BOOL finished) {
                    if (finished) {
                        if (easeOutFinished) easeOutFinished();
                        [self removeFromSuperview];
                    }
                }];
            }
        }];
    }
    else {
        [UIView animateWithDuration:easeDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                if (easeInFinished) easeInFinished();
                [UIView animateWithDuration:easeDuration delay:easeOutDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    if (finished) {
                        if (easeOutFinished) easeOutFinished();
                        [self removeFromSuperview];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Colors
+ (UIColor *)colorForFeedbackAlertKind:(FeedbackAlertKind)formAlertKind {
    switch (formAlertKind) {
        case ErrorAlert:
            return [FeedbackColor errorColor];
            break;
            
        case WarningAlert:
            return [FeedbackColor warningColor];
            break;
            
        case SuccessAlert:
            return [FeedbackColor successColor];
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *)imageNameForFormAlertKind:(FeedbackAlertKind)formAlertKind {
    switch (formAlertKind) {
        case ErrorAlert:
            return @"ico_alert_error";
            break;
            
        case WarningAlert:
            return @"ico_alert_warning";
            break;
            
        case SuccessAlert:
            return @"ico_alert_success";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *)accessibilityIdentifier {
    switch (_kind) {
        case ErrorAlert:
            return @"errorFeedbackAlert";
            break;
            
        case WarningAlert:
            return @"warningFeedbackAlert";
            break;
            
        case SuccessAlert:
            return @"successFeedbackAlert";
            break;
    }
}

@end
