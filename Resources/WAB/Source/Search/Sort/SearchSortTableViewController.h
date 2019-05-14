//
//  OFOrderingViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 8/4/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSortViewController.h"

@interface SearchSortTableViewController : WMBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SearchSortViewController *baseViewController;
@property (nonatomic, strong) SortOption *optionSelected;

@end
