//
//  WMRetryAlertView.m
//  Walmart
//
//  Created by Renan Cargnin on 12/17/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMRetryAlertView.h"

@interface WMRetryAlertView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMRetryAlertView

- (WMRetryAlertView *)initWithTitle:(NSString *)title message:(NSString *)message retryBlock:(void (^)())retryBlock
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    if (self)
    {
        _titleLabel.text = title;
        _messageLabel.text = message;
        _retryBlock = retryBlock;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setupConstraints];
    }
    return self;
}

- (WMRetryAlertView *)initWithTitle:(NSString *)title message:(NSString *)message retryBlock:(void (^)())retryBlock cancelBlock:(void (^)())cancelBlock
{
    self = [self initWithTitle:title message:message retryBlock:retryBlock];
    if (self)
    {
        _cancelBlock = cancelBlock;
    }
    return self;
}

#pragma mark - Layout
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview)
    {
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1
                                                                    constant:0.0f]];
    }
}

- (void)setupConstraints
{
    if (IS_IPHONE_6)
    {
        _alertTrailingConstraint.constant = 30;
        _alertLeadingConstraint.constant = 30;
    }
    else if (IS_IPHONE_6P)
    {
        _alertTrailingConstraint.constant = 68;
        _alertLeadingConstraint.constant = 68;
    }
    
    [self layoutIfNeeded];
}

#pragma mark - IBAction
- (IBAction)pressedRetry:(id)sender {
    [self removeFromSuperview];
    if (_retryBlock) _retryBlock();
}

- (IBAction)pressedCancel:(id)sender {
    [self removeFromSuperview];
    if (_cancelBlock) _cancelBlock();
}

@end
