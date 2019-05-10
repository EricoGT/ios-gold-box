//
//  WMEmptyView.m
//  Walmart
//
//  Created by Renan Cargnin on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMEmptyView.h"

@interface WMEmptyView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMEmptyView

- (WMEmptyView *)initWithMessage:(NSString *)message {
    if (self = [super init]) {
        [self setMessage:message];
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

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    _messageLabel.attributedText = attributedMessage;
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
