//
//  PaymentSummaryItem.m
//  Walmart
//
//  Created by Bruno Delgado on 1/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "PaymentSummaryItem.h"

@implementation PaymentSummaryItem

+ (UIView *)setup
{
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"PaymentSummaryItem" owner:nil options:nil];
    if (xibArray.count > 0)
    {
        UIView *view = [xibArray firstObject];
        return view;
    }
    return nil;
}

- (void)setLayout
{
    [self.summaryLoader stopAnimating];
    [self.summaryLoader setHidden:YES];
}

@end
