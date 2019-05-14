//
//  WMPinnedView.m
//  Walmart
//
//  Created by Renan on 6/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPinnedView.h"

@implementation WMPinnedView

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *viewsDictionary = @{@"self" : self};
        
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|"
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:nil
                                                                                 views:viewsDictionary]];
        
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|"
                                                                               options:NSLayoutFormatDirectionLeadingToTrailing
                                                                               metrics:nil
                                                                                 views:viewsDictionary]];
    }
}

@end
