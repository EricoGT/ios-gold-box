//
//  LoadMoreTableFooterView.h
//  Walmart
//
//  Created by Renan on 10/20/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMButton;

@interface LoadMoreTableFooterView : UIView

- (LoadMoreTableFooterView *)initWithFrame:(CGRect)frame loadMoreBlock:(void (^)(void))loadMoreBlock;

- (void)startLoadingMore;
- (void)loadMoreSucceeded;
- (void)loadMoreFailed;

@end
