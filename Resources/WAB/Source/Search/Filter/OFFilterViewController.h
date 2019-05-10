//
//  OFFilterViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 11/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Filter;
@class SearchCategoryResult;
@class RetryErrorView;

@interface OFFilterViewController : WMBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SearchCategoryResult *result;
@property (nonatomic, strong) NSString *query;

- (OFFilterViewController *)initWithFiltersData:(Filter *)filtersData query:(NSString *)query;
- (OFFilterViewController *)initWithQuery:(NSString *)query title:(NSString *)title;

@end
