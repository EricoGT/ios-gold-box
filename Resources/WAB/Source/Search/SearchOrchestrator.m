//
//  WMBSearchBarDelegate.m
//  Walmart
//
//  Created by Renan Cargnin on 21/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "SearchOrchestrator.h"

#import "WMBSearchView.h"
#import "CategoriesConnection.h"

#import "SearchSuggestion.h"
#import "SearchCategoryResult.h"
#import "FilterDepartment.h"

#import "SortOption.h"

#import "SearchResultHeaderView.h"
#import "LoadMoreTableFooterView.h"

#import "UIViewController+Login.h"
#import "UIViewController+Product.h"
#import "WMBaseViewController.h"
#import "UISearchBar+CancelButton.h"

#import "SearchSortViewController.h"
#import "FilterNavigationController.h"
#import "WBRSearchManager.h"

@interface SearchOrchestrator () <WMBSearchViewDelegate, FilterDelegate, FilterNavigationControllerDelegate>

@property (strong, nonatomic) NSTimer *suggestionsTimer;

@property (strong, nonatomic) NSString *originalQuery;
@property (strong, nonatomic) NSString *currentQuery;
@property (strong, nonatomic) SortOption *sortOption;

@property (assign, nonatomic) NSUInteger nextPage;

@property (strong, nonatomic) SearchCategoryResult *searchResult;
@property (strong, nonatomic) SearchSortViewController *sortViewController;

@end

@implementation SearchOrchestrator

- (void)setSearchBar:(UISearchBar *)searchBar {
    searchBar.delegate = self;
    [searchBar customCancelButtonWithTitle:@"Cancelar" tintColor:RGB(255, 255, 255)];
    
    _searchBar = searchBar;
}

- (void)setSearchView:(WMBSearchView *)searchView {
    searchView.delegate = self;
    searchView.recentSearches = [[NSUserDefaults standardUserDefaults] valueForKey:@"recentSearches"];
    
    _searchView = searchView;
}

- (void)setSearchResult:(SearchCategoryResult *)searchResult {

    _searchResult = searchResult;
    self.nextPage = 2;
    _searchView.products = searchResult.products;
    int ttProducts = _searchResult.count.intValue;
    
    if ([self.currentQuery containsString:@"fq="]) {
        self.searchView.resultTableView.tableHeaderView = nil;
    } else {
        self.searchView.resultTableView.tableHeaderView = [SearchResultHeaderView new];
        SearchResultHeaderView *resultHeaderView = (SearchResultHeaderView *) _searchView.resultTableView.tableHeaderView;
        [resultHeaderView setupWithCount:ttProducts term:self.searchBar.text];
    }
    
    _searchView.resultTableView.contentOffset = CGPointZero;
    
    if (searchResult.products.count > 0) {
        _searchView.state = WMBSearchViewStateResult;
    }
    else {
        _searchView.state = WMBSearchViewStateError;
        if (_searchBar.text.length > 0) {
            NSString *searchedTermString = [NSString stringWithFormat:@"\"%@\"", _searchBar.text];
            NSString *emptyMessage = [NSString stringWithFormat:@"Procuramos por %@ e não encontramos nenhum resultado.", searchedTermString];
            NSRange termRange = [emptyMessage rangeOfString:searchedTermString];
            
            NSMutableAttributedString *attributedEmptyMessage = [[NSMutableAttributedString alloc] initWithString:emptyMessage];
            if (termRange.location != NSNotFound) {
                [attributedEmptyMessage addAttribute:NSForegroundColorAttributeName value:RGBA(244, 123, 32, 1) range:termRange];
            }
            [_searchView showEmptyViewWithAttributedMessage:attributedEmptyMessage.copy];
        }
        else {
            [_searchView showEmptyViewWithMessage:@"Nenhum resultado encontrado."];
        }
    }
    
    [WMOmniture trackSearchResultAction:ACTION_SEARCH_PRODUCTS_RESULT quantity:ttProducts searchedTerm:_searchBar.text];
}

- (void)resetSearch {
    _searchBar.text = @"";
    [_searchBar setShowsCancelButton:NO animated:YES];
    _searchView.state = WMBSearchViewStateRecentSearch;
    _searchView.searchSuggestion = nil;
    _searchView.products = @[];
}

#pragma mark - Connection
- (void)loadSuggestions {
    __block NSString *query = _searchBar.text;
    
    [WBRSearchManager getSearchSuggestionsWithQuery:query completionBlock:^(SearchSuggestion *searchSuggestion) {
        if ([query isEqualToString:self->_searchBar.text] && self->_searchView.state != WMBSearchViewStateResult && self->_searchView.state != WMBSearchViewStateLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_searchView.searchSuggestion = searchSuggestion;
                self->_searchView.state = searchSuggestion.suggestions.count + searchSuggestion.departments.count > 0 ? WMBSearchViewStateSuggestion : WMBSearchViewStateRecentSearch;
            });
        }
    } failureBlock:^(NSError *error) {
        if ([query isEqualToString:self->_searchBar.text] && self->_searchView.state != WMBSearchViewStateResult && self->_searchView.state != WMBSearchViewStateLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_searchView.state = WMBSearchViewStateRecentSearch;
            });
        }
    }];
}

- (BOOL)searchMyAccountTermsInSearchedTerm:(NSString*)term {
    NSArray<NSString *> *terms = @[
                                 @"minha conta",
                                 @"acessar minha conta",
                                 @"entrar na minha conta",
                                 @"minhaconta",
                                 @"entrar em minha conta",
                                 @"meus dados",
                                 @"dados cadastrais"
                                 ];
    
    if ([terms containsObject:[term lowercaseString]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)searchOrdersTermsInSearchedTerm:(NSString*)term {
    NSArray<NSString *> *terms = @[
                                   @"meus pedidos",
                                   @"pedidos",
                                   @"meu pedido",
                                   @"acompanhar pedido",
                                   @"seus pedidos",
                                   @"meus perdidos"
                                   ];
    
    if ([terms containsObject:[term lowercaseString]]) {
        return YES;
    }
    
    return NO;
}

- (void)searchWithQuery:(NSString *)query resetOriginalQuery:(BOOL)resetOriginalQuery searchedTerm:(NSString *)searchedTerm {
    
    if ([self searchOrdersTermsInSearchedTerm:searchedTerm]) {
        
        if ([_delegate respondsToSelector:@selector(searchOrchestratorSearchBarOpenOrders)]) {
            [_delegate searchOrchestratorSearchBarOpenOrders];
        }
        
    } else if ([self searchMyAccountTermsInSearchedTerm:searchedTerm]) {
    
        if ([_delegate respondsToSelector:@selector(searchOrchestratorSearchBarOpenMyAccount)]) {
            [_delegate searchOrchestratorSearchBarOpenMyAccount];
        }
        
    } else {
        
        if (resetOriginalQuery) {
            self.originalQuery = query;
            self.sortOption = nil;
        }
        
        self.currentQuery = query;
        
        _searchView.state = WMBSearchViewStateLoading;
        
        [[CategoriesConnection new] getCategoriesWithQuery:query sortParameter:_sortOption.urlParameter completionBlock:^(id result) {
            if (self->_searchView.state == WMBSearchViewStateLoading) {
                UTMIModel *utmi = [WMUTMIManager UTMI];
                if (searchedTerm.length > 0) {
                    if (utmi.section.length == 0) {
                        [utmi setSection:@"resultado-busca" cleanOtherFields:YES];
                    }
                    utmi.module = @"resultado-busca";
                }
                [WMUTMIManager storeUTMI:utmi];
                
                [FlurryWM logEvent_search_didEnterCategoryResults];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.searchResult = (SearchCategoryResult *)result;
                });
            }
        } failureBlock:^(NSError *error) {
            if (self->_searchView.state == WMBSearchViewStateLoading) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_searchView.state = WMBSearchViewStateError;
                    [self->_searchView showEmptyViewWithMessage:error.localizedDescription];
                });
            }
        }];
    }
    
    
    
}

- (void)loadMoreProducts {
    NSString *query = [NSString stringWithFormat:@"%@&PageNumber=%ld", _currentQuery, (long)_nextPage];
    [[CategoriesConnection new] getCategoriesWithQuery:query sortParameter:_sortOption.urlParameter completionBlock:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SearchCategoryResult *searchResult = (SearchCategoryResult *)result;
            
            if (searchResult.products.count > 0) {
                
//                SearchCategory *category = searchResult.products[0];
                
                 int ttProducts = (int)searchResult.products.count;
                
                if (ttProducts > 0) {
                    [FlurryWM logEvent_search_didResultProductPage:@(self->_nextPage)];
                    
                    [self->_searchView.loadMoreView loadMoreSucceeded];
                    self->_searchView.products = [self->_searchView.products arrayByAddingObjectsFromArray:searchResult.products];
                    
                    self.nextPage++;
                }
                else {
                    self->_searchView.endReached = YES;
                }
            }
            else {
                self->_searchView.endReached = YES;
            }
        });
    } failureBlock:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self->_searchView.loadMoreView loadMoreFailed];
         });
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if ([_delegate respondsToSelector:@selector(searchOrchestratorSearchBarDidBeginEditing)]) {
        [_delegate searchOrchestratorSearchBarDidBeginEditing];
    }
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    dispatch_async(dispatch_get_main_queue(), ^{
        [searchBar reenableCancelButton];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self resetSearch];
    if ([_delegate respondsToSelector:@selector(searchOrchestratorSearchBarCancelButtonClicked)]) {
        [_delegate searchOrchestratorSearchBarCancelButtonClicked];
    }
    
    [FlurryWM logEvent_search_didCancel];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    _searchView.state = WMBSearchViewStateRecentSearch;
    
    [self.suggestionsTimer invalidate];
    if (searchText.length < 2) {
        return;
    }
    self.suggestionsTimer = [NSTimer scheduledTimerWithTimeInterval:0.8f
                                                             target:self
                                                           selector:@selector(loadSuggestions)
                                                           userInfo:nil
                                                            repeats:NO];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return ([searchBar.text length] + [text length] - range.length <= 50) || [text isEqualToString:@"\n"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_suggestionsTimer invalidate];
    if (searchBar.text.length > 0) {
        [FlurryWM logEvent_search_go:searchBar.text];
    }
    [searchBar resignFirstResponder];
    [searchBar reenableCancelButton];
    
    _searchView.recentSearches = [self saveRecentSearchTerm:searchBar.text];
    
    NSString *query = [NSString stringWithFormat:@"ft=%@", searchBar.text];
    [self searchWithQuery:query resetOriginalQuery:YES searchedTerm:searchBar.text];
}

#pragma mark - SearchSuggestionsViewDelegate
- (void)searchViewSelectedSuggestion:(NSString *)suggestion {
    if (suggestion.length > 0) {
        [FlurryWM logEvent_search_go:suggestion];
    }
    
    _searchBar.text = suggestion;
    _searchView.recentSearches = [self saveRecentSearchTerm:_searchBar.text];
    
    [_searchBar resignFirstResponder];
    [_searchBar reenableCancelButton];
    
    NSString *query = [NSString stringWithFormat:@"ft=%@", suggestion];
    [self searchWithQuery:query resetOriginalQuery:YES searchedTerm:suggestion];
}

- (void)searchViewSelectedDepartmentWithName:(NSString *)name {
    _searchBar.text = _searchView.searchSuggestion.suggestedTerm;
    _searchView.recentSearches = [self saveRecentSearchTerm:_searchBar.text];
    
    [_searchBar resignFirstResponder];
    [_searchBar reenableCancelButton];
    
    [FlurryWM logEvent_search_didResultCategoryButton:name];

    FilterDepartment *fakeDepartment = [FilterDepartment new];
    fakeDepartment.name = name;
    NSString *path = [NSString stringWithFormat:@"ft=%@&fq=DN:%@", _searchView.searchSuggestion.suggestedTerm , fakeDepartment.name];
    fakeDepartment.filterValue = path;
    fakeDepartment.url = path;
    
    NSString *query = fakeDepartment.filterValue.length > 0 ? fakeDepartment.filterValue : fakeDepartment.url;
    [self searchWithQuery:query resetOriginalQuery:YES searchedTerm:_searchBar.text];
}

- (void)searchViewRequestedToClearRecentSearches {
    [[NSUserDefaults standardUserDefaults] setValue:@[] forKey:@"recentSearches"];
    _searchView.recentSearches = @[];
}

#pragma mark - SearchResultViewDelegate
- (void)searchViewSelectedProduct:(SearchProduct *)product {
    [_searchBar resignFirstResponder];
    [_presenterController openProductWithID:product.productId.stringValue];
    [FlurryWM logEvent_search_productEntering:product.title];
}

- (void)searchViewRequestedMoreProducts {
    [self loadMoreProducts];
}

- (void)searchViewRequestedToPresentLoginWithSuccessBlock:(void (^)())successBlock {
    [_presenterController presentLoginWithLoginSuccessBlock:successBlock];
}

- (void)searchViewRequestedToPresentSortOptions {
    [FlurryWM logEvent_productSearchSortBtn];
    
    [_searchBar resignFirstResponder];
    
    _sortViewController = [[SearchSortViewController alloc] initWithSelectedOption:_sortOption delegate:self];
    [_presenterController.navigationController addChildViewController:_sortViewController];
    _sortViewController.view.frame = _presenterController.navigationController.view.bounds;
    [_presenterController.navigationController.view addSubview:_sortViewController.view];
    [_sortViewController didMoveToParentViewController:_presenterController.navigationController];
}

- (void)dismissSearchSort {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_sortViewController.view removeFromSuperview];
        self->_sortViewController = nil;
    });
    
}

- (void)searchViewRequestedToPresentFilter {
    FilterNavigationController *filterNavigation = [[FilterNavigationController alloc] initWithFiltersData:_searchResult.filters originalQuery:_originalQuery currentQuery:_currentQuery filterDelegate:self];
    [_presenterController presentViewController:filterNavigation animated:YES completion:nil];
}

#pragma mark - FilterDelegate
- (void)sortDidSelectOption:(NSInteger)optionIndex fromOptions:(NSArray *)options {
    self.sortOption = [options objectAtIndex:optionIndex];
    
    NSDictionary *sortFlurryDictionary = @{@"word" : _searchBar.text ?: @"",
                                           @"type" : _sortOption.name ?: @""};
    [FlurryWM logEvent_search_result_sort:sortFlurryDictionary];
    
    [self searchWithQuery:_currentQuery resetOriginalQuery:NO searchedTerm:_searchBar.text];
}

#pragma mark - FilterNavigationControllerDelegate
- (void)filterContentWithResult:(SearchCategoryResult *)result query:(NSString *)query {
    if (result) {
        self.currentQuery = query;
        self.searchResult = result;
        [self logFilterInfoToFlurryWithResult:result];
    }
}

- (void)logFilterInfoToFlurryWithResult:(SearchCategoryResult *)result {
    //Category
    NSMutableArray *filters = [NSMutableArray new];
    if (result.filters.departments.count > 0) {
        FilterDepartment *department = result.filters.departments[0];
        if (department.name) [filters addObject:department.name];
    }
    
    //Specs
    NSArray *specs = result.filters.specs;
    for (FilterSpec *spec in specs) {
        BOOL addSpec = NO;
        for (FilterSpecValue *specValue in spec.values) {
            if (specValue.selected) {
                addSpec = YES;
                break;
            }
        }
        if (addSpec) [filters addObject:spec.name];
    }
    
    //Price Range
    BOOL addPrice = NO;
    for (FilterSpecValue *specValue in result.filters.pricesRange) {
        if (specValue.selected) {
            addPrice = YES;
            break;
        }
    }
    if (addPrice) [filters addObject:@"Faixa de preço"];
    
    //Brands
    BOOL addBrands = NO;
    for (FilterSpecValue *specValue in result.filters.brands) {
        if (specValue.selected) {
            addBrands = YES;
            break;
        }
    }
    if (addBrands) [filters addObject:@"Marca"];
    
    if (filters.count > 0) {
        NSString *filtersParameter = [[filters.copy valueForKey:@"description"] componentsJoinedByString:@","];
        NSDictionary *filterFlurryDictionary = @{@"filters" : filtersParameter ?: @"", @"word" : _searchBar.text ?: @""};
        [FlurryWM logEvent_search_result_filter:filterFlurryDictionary];
    }
}


#pragma mark - Recent Searches
- (NSArray *)saveRecentSearchTerm:(NSString *)searchTerm {
    NSMutableArray *recentSearches = [[[NSUserDefaults standardUserDefaults] valueForKey:@"recentSearches"] mutableCopy];
    if (recentSearches == nil) {
        recentSearches = [NSMutableArray new];
    }
    
    NSMutableArray *recentSearchesCopy = recentSearches.copy;
    for (NSString *term in recentSearchesCopy) {
        if ([term caseInsensitiveCompare:searchTerm] == NSOrderedSame) {
            [recentSearches removeObjectAtIndex:[recentSearches indexOfObject:term]];
        }
    }
    [recentSearches insertObject:searchTerm atIndex:0];
    
    //limit to 5
    if (recentSearches.count == 6) {
        [recentSearches removeObjectAtIndex:5];
    }
    [[NSUserDefaults standardUserDefaults] setValue:recentSearches forKey:@"recentSearches"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return recentSearches;
}

@end
