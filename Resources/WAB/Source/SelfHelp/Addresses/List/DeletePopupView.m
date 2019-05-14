//
//  DeleteAddressAlert.m
//  Walmart
//
//  Created by Renan on 5/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "DeletePopupView.h"

#import "AddressModel.h"
#import "MyAddressesConnection.h"

@interface DeletePopupView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelAndButtonsVerticalSpaceConstraint;

@end

@implementation DeletePopupView

- (DeletePopupView *)initWithTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)())cancelBlock deleteBlock:(void (^)())deleteBlock {
    if (self = [super init]) {
        [self setTitle:title];
        [self setMessage:message];
        
        _cancelBlock = cancelBlock;
        _deleteBlock = deleteBlock;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
    _messageLabelAndButtonsVerticalSpaceConstraint.constant = message.length > 0 ? 25.0f : 0.0f;
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

#pragma mark - IBAction
- (IBAction)cancelPressed:(id)sender {
    [self removeFromSuperview];
    if (_cancelBlock) _cancelBlock();
}

- (IBAction)deletePressed:(id)sender {
    [self removeFromSuperview];
    if (_deleteBlock) _deleteBlock();
}

@end
