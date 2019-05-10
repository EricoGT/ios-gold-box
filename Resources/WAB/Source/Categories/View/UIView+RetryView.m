//
//  UIView+Retry.m
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIView+RetryView.h"

#import "WMRetryView.h"

@implementation UIView (RetryView)

- (void)showRetryViewWithMessage:(NSString *)message retryBlock:(void (^)())retryBlock {
    WMRetryView *retryView = [[WMRetryView alloc] initWithMessage:message retryBlock:retryBlock];
    [self addSubview:retryView];
}

- (void)removeRetryView {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[WMRetryView class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
