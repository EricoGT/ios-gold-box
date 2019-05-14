//
//  WMButton.m
//  Walmart
//
//  Created by Renan Cargnin on 1/9/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMButton.h"
#import "UIImage+Additions.h"

@interface WMButton ()

@property (strong, nonatomic) NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@end

@implementation WMButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andButtonPressedBlock:(void (^)(void))buttonPressed
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonPressedBlock = buttonPressed;
        self.backgroundColor = RGBA(26, 117, 207, 255);
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.normalColor = self.backgroundColor;
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    self.exclusiveTouch = YES;
    
    if (self.frame.size.height >= 34.f || self.frame.size.height <= 37.0f) {
        self.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:13];
    }
    else if (self.frame.size.height == 44.f) {
        self.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    }
    
    if (self.shadowBorder) [self.shadowBorder removeFromSuperview];
    self.shadowBorder = [UIView new];
    _shadowBorder.translatesAutoresizingMaskIntoConstraints = NO;
    _shadowBorder.backgroundColor = _normalShadowColor;
    [self addSubview:_shadowBorder];
    
    self.topConstraint = [NSLayoutConstraint constraintWithItem:_shadowBorder
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0f
                                                       constant:0.0f];
    
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:_shadowBorder
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self addConstraint:_bottomConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowBorder
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowBorder
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_shadowBorder
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:3.0f]];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (!self.highlighted) {
        self.backgroundColor = normalColor;
    }
    const CGFloat *normalCG = CGColorGetComponents(self.normalColor.CGColor);
    self.normalShadowColor = [UIColor colorWithRed:(normalCG[0] * 0.8f) green:(normalCG[1] * 0.8f) blue:(normalCG[2] * 0.8f) alpha:1];
    self.highlightedColor = self.normalShadowColor.copy;
    const CGFloat *highlightedCG = CGColorGetComponents(self.highlightedColor.CGColor);
    self.highlightedShadowColor = [UIColor colorWithRed:(highlightedCG[0] * 0.8f) green:(highlightedCG[1] * 0.8f) blue:(highlightedCG[2] * 0.8f) alpha:1];
}

- (void)setNormalShadowColor:(UIColor *)normalShadowColor {
    _normalShadowColor = normalShadowColor;
    if (!self.highlighted) {
        self.shadowBorder.backgroundColor = normalShadowColor;
    }
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
    if (self.highlighted) {
        self.backgroundColor = highlightedColor;
    }
}

- (void)setHighlightedShadowColor:(UIColor *)highlightedShadowColor {
    _highlightedShadowColor = highlightedShadowColor;
    if (self.highlighted) {
        self.shadowBorder.backgroundColor = highlightedShadowColor;
    }
}

- (void)setIconImage:(UIImage *)iconImage {
    [self setImage:iconImage forState:UIControlStateNormal];
    [self setImage:iconImage forState:UIControlStateHighlighted];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -iconImage.size.width, 0, 0)];
}

#pragma Touch Recognition

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        self.backgroundColor = self.highlightedColor;
        self.shadowBorder.backgroundColor = self.highlightedShadowColor;
        
        [self removeConstraint:_bottomConstraint];
        [self addConstraint:_topConstraint];
    }
    else
    {
        self.backgroundColor = self.normalColor;
        self.shadowBorder.backgroundColor = self.normalShadowColor;
        
        [self removeConstraint:_topConstraint];
        [self addConstraint:_bottomConstraint];
    }
}

- (void)buttonPressed:(id)sender {
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock();
    };
}

@end

