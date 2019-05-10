//
//  RetryView.m
//  Walmart
//
//  Created by Renan Cargnin on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMRetryView.h"

@interface WMRetryView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMRetryView

- (WMRetryView *)initWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock {
    self = [super init];
    if (self) {
        [self setMessage:message];
        [self setRetryBlock:retryBlock];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _messageLabel.preferredMaxLayoutWidth = _messageLabel.bounds.size.width;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self layoutIfNeeded];
    [self layoutSubviews];
}

- (void)setMessage:(NSString *)message {
    _messageLabel.text = message;
}

- (IBAction)pressedRetry {
    [self removeFromSuperview];
    if (_retryBlock) _retryBlock();
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

@end
