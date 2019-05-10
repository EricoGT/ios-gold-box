//
//  FilterBaseViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 8/4/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortOption.h"

@protocol FilterDelegate <NSObject>
@optional
- (void)sortDidSelectOption:(NSInteger)optionIndex fromOptions:(NSArray *)options;
@end

@interface SearchSortViewController : WMBaseViewController

- (SearchSortViewController *)initWithSelectedOption:(SortOption *)selectedOption delegate:(id <FilterDelegate>)delegate;

- (void)dismiss;
- (void)selectOption:(NSInteger)optionIndex fromOptions:(NSArray *)options;
@end
