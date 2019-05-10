//
//  WMButtonRounded.h
//  Walmart
//
//  Created by Marcelo Santos on 11/28/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WMBRoundedButtonStyleCustom = 0,
    WMBRoundedButtonStyleWhite = 1,
    WMBRoundedButtonStyleBlue = 2,
    WMBRoundedButtonStyleFacebook = 3,
    WMBRoundedButtonStyleGreen = 4,
    WMBRoundedButtonStyleLightBlue = 5,
    WMBRoundedButtonStyleWishlistGreen = 6,
    WMBRoundedButtonStyleWishlistYellow = 7,
    WMBRoundedButtonStyleVariationsBlue = 8,
    WMBRoundedButtonStyleVariationsWhite = 9,
    WMBRoundedButtonStyleProductDetailWhite = 10
    
} WMBRoundedButtonStyle;

IB_DESIGNABLE
@interface WMButtonRounded : UIButton

@property (nonatomic, strong) UIImage *iconImage;

@property (assign, nonatomic) IBInspectable NSUInteger roundedButtonStyle;

- (void)setFont:(UIFont *)font;

@end
