//
//  NSString+Additions.m
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (CGSize)sizeForTextWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSString *text = (NSString *)self;
    if ((size.width == 0) && ((size.height == 0))) size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGRect expectedFrame = [text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]
                                              context:nil];
    CGSize theSize = CGSizeMake(expectedFrame.size.width, expectedFrame.size.height);
    return CGSizeMake(ceil(theSize.width), ceil(theSize.height));
}

- (NSString *)stringByRemovingAccentuation {
    return [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
}

@end
