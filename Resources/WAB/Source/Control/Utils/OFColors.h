//
//  OFColors.h
//  Ofertas
//
//  Created by Marcelo Santos on 9/27/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface OFColors : NSObject

- (UIColor *) convertToArrayColorsFromString:(NSString *) colors;
- (NSString *) convertToStringColorsFromArray:(NSArray *) arrColors;

+ (UIImage *)imageWithColor:(NSString *)strColor andSize:(CGSize)size;
+ (UIColor *) convertToArrayColorsFromString:(NSString *) colors;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
