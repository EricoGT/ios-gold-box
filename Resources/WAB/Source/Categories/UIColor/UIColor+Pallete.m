//
//  UIColor+Pallete.m
//  Walmart
//
//  Created by Renan Cargnin on 28/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UIColor+Pallete.h"

@implementation UIColor (Pallete)

+ (UIColor *)colorWithWMBColorOption:(WMBColorOptions)wmbColorOption alpha:(CGFloat)alpha {
    switch (wmbColorOption) {
        case WMBColorOptionLightBlue:
            return RGBA(33.0f, 150.0f, 243.0f, alpha);
            
        case WMBColorOptionDarkBlue:
            return RGBA(26.0f, 117.0f, 207.0f, alpha);
            
        case WMBColorOptionFacebookBlue:
            return RGBA(59.0f, 89.0f, 152.0f, alpha);
            
        case WMBColorOptionFacebookDarkBlue:
            return RGBA(47.0f, 73.0f, 127.0f, alpha);
            
        case WMBColorOptionDarkGray:
            return RGBA(102.0f, 102.0f, 102.0f, alpha);
    }
}

+ (UIColor *)colorWithWMBColorOption:(WMBColorOptions)wmbColorOption {
    return [UIColor colorWithWMBColorOption:wmbColorOption alpha:1.0f];
}

@end
