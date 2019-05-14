//
//  OFColors.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/27/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFColors.h"
#import "PSLog.h"

@implementation OFColors

- (UIColor *) convertToArrayColorsFromString:(NSString *) colors {
    
    NSArray *colorBarArr = [colors componentsSeparatedByString:@","];
    
    float colorR = [[colorBarArr objectAtIndex:0] floatValue]/255.0f;
    float colorG = [[colorBarArr objectAtIndex:1] floatValue]/255.0f;
    float colorB = [[colorBarArr objectAtIndex:2] floatValue]/255.0f;
    float colorA = [[colorBarArr objectAtIndex:3] floatValue]/255.0f;
    
    UIColor *color = [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:colorA];
    
    return color;
}

- (NSString *) convertToStringColorsFromArray:(NSArray *) arrColors {
    
    NSString *stringColor = @"";
    
    if ([arrColors count] == 4) {
        
        NSString *colorR = [arrColors objectAtIndex:0];
        NSString *colorG = [arrColors objectAtIndex:1];
        NSString *colorB = [arrColors objectAtIndex:2];
        NSString *colorA = [arrColors objectAtIndex:3];
        stringColor = [NSString stringWithFormat:@"%@,%@,%@,%@", colorR, colorG, colorB, colorA];
    } else {
        
        LogErro(@"Received invalid array with colors");
        stringColor = @"0,0,0,255";
    }

    return stringColor;
}



+ (UIImage *)imageWithColor:(NSString *)strColor andSize:(CGSize)size {
    
    UIColor *color = [self convertToArrayColorsFromString:strColor];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image;
    
    if (context != NULL)
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        image = nil;
    }
    
    return image;
}


+ (UIColor *) convertToArrayColorsFromString:(NSString *) colors {
    
    NSArray *colorBarArr = [colors componentsSeparatedByString:@","];
    
    float colorR = [[colorBarArr objectAtIndex:0] floatValue]/255.0f;
    float colorG = [[colorBarArr objectAtIndex:1] floatValue]/255.0f;
    float colorB = [[colorBarArr objectAtIndex:2] floatValue]/255.0f;
    float colorA = [[colorBarArr objectAtIndex:3] floatValue]/255.0f;
    
    UIColor *color = [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:colorA];
    
    return color;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *image = nil;
    if (context)
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *image = nil;
    if (context)
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
