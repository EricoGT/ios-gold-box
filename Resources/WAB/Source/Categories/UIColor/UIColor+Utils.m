//
//  UIColor+Utils.m
//  Walmart
//
//  Created by Bruno on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (instancetype)colorWithArray:(NSArray *)values; {
    if (values.count < 3) return nil;
    
    float _red = [values[0] floatValue];
    float _green = [values[1] floatValue];
    float _blue = [values[2] floatValue];
    float _alpha = values.count > 3 ? [values[3] floatValue] : 1.0f;
    return RGBA(_red, _green, _blue, _alpha);
}


@end
