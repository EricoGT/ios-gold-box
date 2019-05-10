//
//  ExtendedWarrantyListViewController.h
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

@class WMMyAccountViewController, WMButton, RetryErrorView;

@interface ExtendedWarrantyListViewController : WMBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) NSArray *warranties;

@property (assign, nonatomic) BOOL endOfWarrantiesReached;
@property (assign, nonatomic) NSUInteger lastPageNumber;

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *noWarrantiesLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadMoreLoader;

@property (weak, nonatomic) IBOutlet WMButton *retryLoadMoreButton;
@property (strong, nonatomic) RetryErrorView *retryView;

@property (strong, nonatomic) WMMyAccountViewController *myAccountReference;

- (void)loadExtendedWarranties;
- (void)loadSuccessWithWarranties:(NSArray *)warranties;
- (void)loadFailureWithError:(NSString *)error;

- (IBAction)loadMore;
- (void)loadMoreSuccessWithWarranties:(NSArray *)warranties;
- (void)loadMoreFailure;

- (IBAction)goToShopping:(id)sender;

@end
