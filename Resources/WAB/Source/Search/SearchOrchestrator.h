//
//  WMBSearchBarDelegate.h
//  Walmart
//
//  Created by Renan Cargnin on 21/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WMBSearchView;

@protocol SearchOrchestratorDelegate <NSObject>
@optional
- (void)searchOrchestratorSearchBarDidBeginEditing;
- (void)searchOrchestratorSearchBarCancelButtonClicked;
- (void)searchOrchestratorSearchBarOpenOrders;
- (void)searchOrchestratorSearchBarOpenMyAccount;
@end

@interface SearchOrchestrator : NSObject <UISearchBarDelegate>

@property (weak) id <SearchOrchestratorDelegate> delegate;

/**
 * @brief Search bar that will trigger search interactions
 */
@property (weak, nonatomic) UISearchBar *searchBar;

/**
 * @brief View where search suggestions and results will be displayed
 */
@property (weak, nonatomic) WMBSearchView *searchView;

/**
 * @brief View Controller responsible for presenting content such as product detail, login, filters and sort options
 */
@property (weak, nonatomic) UIViewController *presenterController;

/**
 *  Performs a search with a determined query
 *
 *  @param query NSString with the query that should be sent to search service
 *  @param showcaseId NSString with the showcase if it's coming from to register in the retargeting
 */
- (void)searchWithQuery:(NSString *)query resetOriginalQuery:(BOOL)resetOriginalQuery searchedTerm:(NSString *)searchedTerm;

/**
 *  Resets search to its initial state
 */
- (void)resetSearch;


- (void)dismissSearchSort;

@end
