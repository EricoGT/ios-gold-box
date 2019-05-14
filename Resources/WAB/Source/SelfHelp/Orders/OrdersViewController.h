//
//  HomeViewController.h
//  Tracking
//
//  Created by Bruno Delgado on 4/16/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "WALMenuItemViewController.h"

@class TrackingEntity;
@class TrackingOrder;
@class LoadMoreCell;
@class WMButton;
@class WMMyAccountViewController;

@interface OrdersViewController : WALMenuItemViewController

@property (nonatomic, strong) TrackingEntity *tracking;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, strong) LoadMoreCell *loadMoreCell;
@property (nonatomic, strong) WMButtonRounded *retryButton;

// Public for tests
@property (nonatomic, weak) IBOutlet UIView *emptyView;
@property (nonatomic, weak) IBOutlet UIImageView *errorImageView;
@property (nonatomic, weak) IBOutlet UILabel *emptyMessageLabel;

- (void)reloadUI;
- (void)setEmptyState;
- (void)setErrorState:(NSError *)error;
- (void)increasePage;
- (void)updatePageForLoadMore;

@end
