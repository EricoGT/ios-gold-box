//
//  HubOffersTableViewController.h
//  Walmart
//
//  Created by Bruno on 7/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseViewController.h"
@class SearchProductHubConnection;

@protocol HubOffersDelegate <NSObject>
@optional
- (void)productSelectedOnHubOffer:(SearchProductHubConnection *)product;
@end

@interface HubOffersViewController : WMBaseViewController

@property (nonatomic, assign) id <HubOffersDelegate> delegate;

//Designated initializers
- (HubOffersViewController *)initWithCategoryId:(NSString *)categoryId;

- (id)initWithFrame:(CGRect)frame  __attribute__((unavailable("Use -initWithCategoryId:")));
- (id)initWithCoder:(NSCoder *)aDecoder  __attribute__((unavailable("Use -initWithCategoryId:")));
- (id)init  __attribute__((unavailable("Use -initWithCategoryId:")));
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  __attribute__((unavailable("Use -initWithCategoryId:")));
- (id)initWithStyle:(UITableViewStyle)style  __attribute__((unavailable("Use -initWithCategoryId:")));

- (void)handleTableViewInsets:(UIEdgeInsets)insets;

@end
