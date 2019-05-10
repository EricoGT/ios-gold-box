//
//  WMSeePwdSwitch.m
//  Walmart
//
//  Created by Renan Cargnin on 3/31/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMSeePwdButton.h"

@implementation WMSeePwdButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSeePwdButton];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:40.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:40.0f]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSeePwdButton];
    }
    return self;
}

- (void)setupSeePwdButton {
    [self setOn:NO];
    [self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOn:(BOOL)on {
    _on = on;
    
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_%@_password", _on ? @"hide" : @"show"]] forState:UIControlStateNormal];
    
    if (_textField) {
        [_textField setSecureTextEntry:!on];
        
        //Prevent font bug
        if (on) {
            [_textField setAttributedText:[[NSAttributedString alloc] initWithString:_textField.text]];
        }
    }
}

- (void)pressed {
    [self setOn:!_on];
}

- (CGFloat)widthFromConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            return constraint.constant;
        }
    }
    return 0.0f;
}

@end
