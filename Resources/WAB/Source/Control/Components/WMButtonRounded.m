//
//  WMButtonRounded.m
//  Walmart
//
//  Created by Marcelo Santos on 11/28/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMButtonRounded.h"
#import "UIImage+Additions.h"
#import "OFColors.h"

@interface WMButtonRounded ()
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *highlightedBorderColor;

@end

@implementation WMButtonRounded

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setup];
}

- (void)setup {
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.layer.masksToBounds = YES;

    LogInfo(@"self.titleLabel.font: %@", self.titleLabel.font );
    if(self.titleLabel.font == nil){
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    }
    self.exclusiveTouch = YES;
}

- (void)setFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (void)setRoundedButtonStyle:(NSUInteger)roundedButtonStyle {
    UIColor *backgroundColor;
    UIColor *titleColor;
    UIColor *highlightedBackgroundColor;
    UIColor *highlightedTitleColor;
    
    UIColor *lightBlueColor = [UIColor colorWithWMBColorOption:WMBColorOptionLightBlue];
    UIColor *darkBlueColor = [UIColor colorWithWMBColorOption:WMBColorOptionDarkBlue];
    UIColor *whiteColor = RGB(255, 255, 255);
    
    switch (roundedButtonStyle) {
        case WMBRoundedButtonStyleWhite:
            backgroundColor = whiteColor;
            titleColor = lightBlueColor;
            highlightedBackgroundColor = backgroundColor;
            highlightedTitleColor = darkBlueColor;
            self.borderColor = lightBlueColor;
            break;
            
        case WMBRoundedButtonStyleBlue:
//            backgroundColor = lightBlueColor;
            backgroundColor = RGB(25, 118, 210);
            titleColor = whiteColor;
            highlightedBackgroundColor = darkBlueColor;
//            highlightedTitleColor = titleColor;
            highlightedBackgroundColor = RGB(28, 98, 168);
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleFacebook:
            backgroundColor = [UIColor colorWithWMBColorOption:WMBColorOptionFacebookBlue];
            titleColor = whiteColor;
            highlightedBackgroundColor = [UIColor colorWithWMBColorOption:WMBColorOptionFacebookDarkBlue];
            highlightedTitleColor = titleColor;
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleGreen:
            backgroundColor = RGB(76, 175, 80);
            titleColor = whiteColor;
            highlightedBackgroundColor = RGB(68, 157, 72);
            highlightedTitleColor = whiteColor;
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleLightBlue:
            backgroundColor = lightBlueColor;
            titleColor = whiteColor;
            highlightedBackgroundColor = darkBlueColor;
            highlightedTitleColor = whiteColor;
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleWishlistGreen:
            backgroundColor = RGB(76, 175, 80);
            titleColor = whiteColor;
            highlightedBackgroundColor = RGB(60, 140, 60);
            highlightedTitleColor = whiteColor;
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleWishlistYellow:
            backgroundColor = RGB(255, 152, 0);
            titleColor = whiteColor;
            highlightedBackgroundColor = RGB(245, 124, 0);
            highlightedTitleColor = whiteColor;
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleVariationsBlue:
            backgroundColor = RGB(33, 150, 243);
            titleColor = whiteColor;
            highlightedBackgroundColor = darkBlueColor;
            highlightedBackgroundColor = RGB(25, 118, 210);
            self.borderColor = nil;
            break;
            
        case WMBRoundedButtonStyleVariationsWhite:
            backgroundColor = whiteColor;
            titleColor = lightBlueColor;
            highlightedBackgroundColor = whiteColor;
            highlightedTitleColor = RGB(25, 118, 210);
            self.borderColor = lightBlueColor;
            self.highlightedBorderColor = RGB(25, 118, 210);
            break;
            
        case WMBRoundedButtonStyleProductDetailWhite:
            backgroundColor = whiteColor;
            titleColor = lightBlueColor;
            highlightedBackgroundColor = RGB(25, 118, 210);
            highlightedTitleColor = whiteColor;
            self.borderColor = lightBlueColor;
            self.highlightedBorderColor = RGB(25, 118, 210);
            break;
            
        default:
            backgroundColor = self.backgroundColor;
            self.borderColor = [UIColor colorWithCGColor:self.layer.borderColor];
            break;
    }
    
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderColor ? 1.0f : 0.0f;
    
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    
    
    
    _roundedButtonStyle = roundedButtonStyle;
}

- (void)setIconImage:(UIImage *)iconImage {
    [self setImage:iconImage forState:UIControlStateNormal];
    [self setImage:iconImage forState:UIControlStateHighlighted];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -iconImage.size.width, 0, 0)];
    self.tintColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(self.highlighted && self.highlightedBorderColor){
        self.layer.borderColor = self.highlightedBorderColor.CGColor;
    }else{
        self.layer.borderColor = self.borderColor.CGColor;
    }
}

@end
