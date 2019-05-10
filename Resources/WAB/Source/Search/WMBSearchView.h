//
//  WMBSearchView.h
//  Walmart
//
//  Created by Renan Cargnin on 21/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

typedef enum : NSUInteger {
    WMBSearchViewStateRecentSearch = 0,
    WMBSearchViewStateSuggestion = 1,
    WMBSearchViewStateResult = 2,
    WMBSearchViewStateLoading = 3,
    WMBSearchViewStateError = 4
} WMBSearchViewState;

@class SearchSuggestionsView, SearchResultView, SearchSuggestion, LoadMoreTableFooterView, SearchProduct;

@protocol WMBSearchViewDelegate <NSObject>
@optional
- (void)searchViewSelectedSuggestion:(NSString *)suggestion;
- (void)searchViewSelectedDepartmentWithName:(NSString *)name;
- (void)searchViewRequestedToClearRecentSearches;
- (void)searchViewRequestedMoreProducts;
- (void)searchViewSelectedProduct:(SearchProduct *)product;
- (void)searchViewRequestedToPresentLoginWithSuccessBlock:(void (^)())successBlock;
- (void)searchViewRequestedToPresentSortOptions;
- (void)searchViewRequestedToPresentFilter;
@end

@interface WMBSearchView : WMView

@property (strong, nonatomic) IBOutlet UIView *suggestionsView;
@property (strong, nonatomic) IBOutlet UITableView *suggestionsTableView;

@property (strong, nonatomic) IBOutlet UIView *resultView;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

@property (strong, nonatomic) LoadMoreTableFooterView *loadMoreView;

@property (weak) id <WMBSearchViewDelegate> delegate;

@property (assign, nonatomic) WMBSearchViewState state;
@property (assign, nonatomic) BOOL endReached;

@property (strong, nonatomic) NSArray *recentSearches;
@property (strong, nonatomic) SearchSuggestion *searchSuggestion;

@property (strong, nonatomic) NSArray *products;

@end
