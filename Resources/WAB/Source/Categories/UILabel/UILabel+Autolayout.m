//
//  UILabel+Autolayout.m
//  Walmart
//
//  Created by Bruno Delgado on 3/8/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UILabel+Autolayout.h"

@implementation UILabel (Autolayout)

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if ([self respondsToSelector:@selector(setPreferredMaxLayoutWidth:)]) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
    }
}

@end
