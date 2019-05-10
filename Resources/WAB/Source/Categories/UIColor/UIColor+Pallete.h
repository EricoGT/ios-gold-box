//
//  UIColor+Pallete.h
//  Walmart
//
//  Created by Renan Cargnin on 28/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WMBColorOptionLightBlue = 0,
    WMBColorOptionDarkBlue = 1,
    WMBColorOptionFacebookBlue = 2,
    WMBColorOptionFacebookDarkBlue = 3,
    WMBColorOptionDarkGray = 4
} WMBColorOptions;

@interface UIColor (Pallete)

+ (UIColor *)colorWithWMBColorOption:(WMBColorOptions)wmbColorOption alpha:(CGFloat)alpha;
+ (UIColor *)colorWithWMBColorOption:(WMBColorOptions)wmbColorOption;

@end
