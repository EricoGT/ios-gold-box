//
//  FilterNavigationController.h
//  Walmart
//
//  Created by Bruno Delgado on 11/14/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCategoryResult;

@protocol FilterNavigationControllerDelegate <NSObject>
@required
- (void)filterContentWithResult:(SearchCategoryResult *)result query:(NSString *)query;
@end

@class SearchCategoryResult, Filter;

@interface FilterNavigationController : UINavigationController

@property (weak) id <FilterNavigationControllerDelegate> filterDelegate;

@property (strong, nonatomic) NSString *originalQuery;

- (FilterNavigationController *)initWithFiltersData:(Filter *)filtersData originalQuery:(NSString *)originalQuery currentQuery:(NSString *)currentQuery filterDelegate:(id<FilterNavigationControllerDelegate>)filterDelegate;

@end
