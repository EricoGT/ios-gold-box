//
//  WMPopupView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/8/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPopupView.h"

@interface WMPopupView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMPopupView

- (WMPopupView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(void (^)())cancelBlock actionButtonTitle:(NSString *)actionButtonTitle actionBlock:(void (^)())actionBlock {
    if (self = [super init]) {
        [self setTitle:title];
        [self setMessage:message];
        
        [self setCancelButtonTitle:cancelButtonTitle];
        [self setActionButtonTitle:actionButtonTitle];
        
        _cancelBlock = cancelBlock;
        _actionBlock = actionBlock;
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
}

- (void)setActionButtonTitle:(NSString *)actionButtonTitle {
    [_actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Auto Layout
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
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
- (IBAction)pressedCancel:(id)sender {
    [self removeFromSuperview];
    if (_cancelBlock) _cancelBlock();
}

- (IBAction)pressedAction:(id)sender {
    [self removeFromSuperview];
    if (_actionBlock) _actionBlock();
}

@end
