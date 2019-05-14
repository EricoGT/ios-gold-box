//
//  UIView+Loading.m
//  Walmart
//
//  Created by Renan Cargnin on 2/12/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIView+Loading.h"

#import "WMLoadingView.h"
#import "WMModalLoadingView.h"
#import "WBRProgressBarView.h"

@implementation UIView (Loading)

- (void)showLoading {
    [self showLoadingWithBackgroundColor:self.backgroundColor loaderColor:RGBA(26, 117, 207, 1)];
}

- (void)showLoadingWithBackgroundColor:(UIColor *)backgroundColor {
    [self showLoadingWithBackgroundColor:backgroundColor loaderColor:RGBA(26, 117, 207, 1)];
}

- (void)showLoadingWithLoaderColor:(UIColor *)loaderColor {
    [self showLoadingWithBackgroundColor:self.backgroundColor loaderColor:loaderColor];
}

- (void)showLoadingWithBackgroundColor:(UIColor *)backgroundColor loaderColor:(UIColor *)loaderColor {
    WMLoadingView *loadingView = [WMLoadingView new];
    loadingView.backgroundColor = backgroundColor;
    loadingView.loader.color = loaderColor;
    [self addSubview:loadingView];
}

- (void)hideLoading {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMLoadingView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Full Screen Loading
- (void)showModalLoading {
    [self addSubview:[WMModalLoadingView new]];
}

- (void)hideModalLoading {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMModalLoadingView class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Smart Loading

- (void)showSmartLoadingWithBackgroundColor:(UIColor *)backgroundColor {
    
    BOOL isAlreadyDisplayingLoadingView = NO;
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMModalLoadingView class]] ||
            [view isKindOfClass:[WMLoadingView class]]) {
            isAlreadyDisplayingLoadingView = YES;
        }
    }
    
    if (!isAlreadyDisplayingLoadingView) {
        
        WMLoadingView *loadingView = [WMLoadingView new];
        loadingView.backgroundColor = backgroundColor;
        loadingView.alpha = 0.0f;
        [self addSubview:loadingView];
        [UIView animateWithDuration:0.5f animations:^{
            loadingView.alpha = 0.7f;
        }];
    }
}

- (void)hideSmartLoading {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMModalLoadingView class]] ||
            [view isKindOfClass:[WMLoadingView class]]) {
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

- (void)showSmartModalLoading {
    [self showSmartModalLoadingWithBackgroundColor:RGBA(33, 150, 243, 0.7f)];
}

- (void)showSmartModalLoadingWithBackgroundColor:(UIColor *)backgroundColor {
    BOOL isAlreadyDisplayingLoadingView = NO;
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMModalLoadingView class]] ||
            [view isKindOfClass:[WMLoadingView class]]) {
            isAlreadyDisplayingLoadingView = YES;
        }
    }
    if (!isAlreadyDisplayingLoadingView) {
        WMModalLoadingView *modalLoadingView = [WMModalLoadingView new];
        [modalLoadingView setBackgroundColor:backgroundColor];
        [self addSubview:modalLoadingView];
    }
}

- (void)hideSmartModalLoading {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WMModalLoadingView class]] ||
            [view isKindOfClass:[WMLoadingView class]]) {
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}


- (void)showSmartModalProgress {
    [self showSmartModalProgressWithBackgroundColor:RGBA(33, 150, 243, 0.7f)];
}

- (void)showSmartModalProgressWithBackgroundColor:(UIColor *)backgroundColor {
    BOOL isAlreadyDisplayingProgressView = NO;
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WBRProgressBarView class]]) {
            isAlreadyDisplayingProgressView = YES;
        }
    }
    if (!isAlreadyDisplayingProgressView) {
        WBRProgressBarView *modalProgressView = [[WBRProgressBarView alloc] init];
        [modalProgressView setBackgroundColor:backgroundColor];
        [self addSubview:modalProgressView];
    }
}

- (void)setProgressValue:(NSNumber *)progress {
    
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WBRProgressBarView class]]) {
            [(WBRProgressBarView *)view setProgressValue:progress];
            return;
        }
    }
}

- (void)hideSmartModalProgress {
    for (UIView *view in self.subviews.copy) {
        if ([view isKindOfClass:[WBRProgressBarView class]]) {
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}


@end
