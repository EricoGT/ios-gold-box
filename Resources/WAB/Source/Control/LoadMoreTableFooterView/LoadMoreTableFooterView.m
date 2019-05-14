//
//  LoadMoreTableFooterView.m
//  Walmart
//
//  Created by Renan on 10/20/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "LoadMoreTableFooterView.h"

#import "WMButton.h"

@interface LoadMoreTableFooterView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet WMButton *retryButton;

@property (nonatomic, copy) void (^loadMoreBlock)(void);

@end

@implementation LoadMoreTableFooterView

- (LoadMoreTableFooterView *)initWithFrame:(CGRect)frame loadMoreBlock:(void (^)(void))loadMoreBlock
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    if (self)
    {
        self.frame = frame;
        _loadMoreBlock = loadMoreBlock;
    }
    return self;
}

- (void)startLoadingMore
{
    _retryButton.hidden = YES;
    [_activityIndicator startAnimating];
    if (_loadMoreBlock) _loadMoreBlock();
}

- (void)loadMoreSucceeded
{
    [_activityIndicator stopAnimating];
}

- (void)loadMoreFailed
{
    [_activityIndicator stopAnimating];
    _retryButton.hidden = NO;
}

- (IBAction)retry
{
    [self startLoadingMore];
}

@end
