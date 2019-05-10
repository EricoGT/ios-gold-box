//
//  ContactRequestPinnedView.m
//  Walmart
//
//  Created by Renan Cargnin on 2/15/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "ContactRequestPinnedView.h"

@implementation ContactRequestPinnedView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        [self.superview removeConstraints:self.superview.constraints];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
        NSArray *arrayOfSubviews = self.superview.subviews;
        
        NSInteger count = 0;
        NSMutableString *subviewMutableString = [NSMutableString new];
        for (UIView *subview in arrayOfSubviews) {
            NSString *subviewString = [NSString stringWithFormat:@"view%ld", (long)count];
            [viewsDictionary setObject:subview forKey:subviewString];
            if (count > 0) {
                [subviewMutableString appendFormat:@"-0-[%@]", subviewString];
            }
            else {
                [subviewMutableString appendFormat:@"[%@]", subviewString];
            }
            
            NSString *horizontalVisualFormatString = [NSString stringWithFormat:@"H:|-0-[%@]-0-|", subviewString];
            [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalVisualFormatString
                                                                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                   metrics:nil
                                                                                     views:viewsDictionary]];
            
            count++;
        }
        
        
        
        NSString *verticalVisualFormatString = [NSString stringWithFormat:@"V:|-0-%@-0-|", subviewMutableString];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalVisualFormatString
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:nil
                                                                                 views:viewsDictionary]];
    }
}

@end
