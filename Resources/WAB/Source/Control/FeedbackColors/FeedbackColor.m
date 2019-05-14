//
//  FeedbackColor.m
//  Walmart
//
//  Created by Renan Cargnin on 4/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "FeedbackColor.h"

@implementation FeedbackColor

+ (UIColor *)successColor {
    return RGBA(76, 175, 80, 1);
}

+ (UIColor *)warningColor {
    return RGBA(255, 152, 0, 1);
}

+ (UIColor *)errorColor {
    return RGBA(244, 67, 54, 1);
}

@end
