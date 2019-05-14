//
//  NSString+Additions.h
//  Tracking
//
//  Created by Bruno Delgado on 4/28/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (CGSize)sizeForTextWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (NSString *)stringByRemovingAccentuation;

@end
