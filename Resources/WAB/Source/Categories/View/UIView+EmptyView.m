//
//  UIView+EmptyView.m
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIView+EmptyView.h"

#import "WMEmptyView.h"

@implementation UIView (EmptyView)

- (void)showEmptyViewWithMessage:(NSString *)message {
    WMEmptyView *emptyView = [WMEmptyView new];
    emptyView.backgroundColor = self.backgroundColor;
    [emptyView setMessage:message];
    [self addSubview:emptyView];
}

- (void)showEmptyViewWithAttributedMessage:(NSAttributedString *)attributedMessage {
    WMEmptyView *emptyView = [WMEmptyView new];
    emptyView.backgroundColor = self.backgroundColor;
    [emptyView setAttributedMessage:attributedMessage];
    [self addSubview:emptyView];
}

- (void)hideEmptyView {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMEmptyView class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
