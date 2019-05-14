//
//  WMMenuErrorView.m
//  Walmart
//
//  Created by Bruno Delgado on 2/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMMenuErrorView.h"

@interface WMMenuErrorView ()

@end

@implementation WMMenuErrorView

+ (UIView *)loadFromXib
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

@end
