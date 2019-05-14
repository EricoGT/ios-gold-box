//
//  JSONValueTransformer+UIColor.m
//  Walmart
//
//  Created by Renan on 6/27/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONValueTransformer+UIColor.h"

#import "UIColor+Utils.h"

@implementation JSONValueTransformer (UIColor)

- (UIColor *)UIColorFromNSArray:(NSArray *)values {
    return [UIColor colorWithArray:values];
}

- (NSArray *)JSONObjectFromUIColor:(UIColor *)color {
    const CGFloat * colorValues = CGColorGetComponents(color.CGColor);
    NSMutableArray *colorsMutable = [NSMutableArray new];
    for (NSInteger i = 0; i < 4; i++) {
        [colorsMutable addObject:@(colorValues[i] * 255.0f)];
    }
    return colorsMutable.copy;
}

@end
