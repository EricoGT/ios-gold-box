//
//  WMPwdTextField.m
//  Walmart
//
//  Created by Renan Cargnin on 4/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMPwdTextField.h"

#import "WMSeePwdButton.h"

@interface WMPwdTextField ()

@property (strong, nonatomic) WMSeePwdButton *seePwdButton;

@end

@implementation WMPwdTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPwdTextField];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPwdTextField];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [_seePwdButton removeFromSuperview];
    
    if (self.superview) {
        [self.superview addSubview:_seePwdButton];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_seePwdButton
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_seePwdButton
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    rect.size.width -= [_seePwdButton widthFromConstraint];
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect.size.width -= [_seePwdButton widthFromConstraint];
    return rect;
}

- (void)setupPwdTextField {
    self.secureTextEntry = YES;
    
    self.seePwdButton = [WMSeePwdButton new];
    _seePwdButton.textField = self;
}

@end
