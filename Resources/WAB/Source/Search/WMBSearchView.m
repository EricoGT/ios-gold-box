//
//  WMBSearchView.m
//  Walmart
//
//  Created by Renan Cargnin on 21/02/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBSearchView.h"

#import "SearchResultHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "ProductCardCell.h"
#import "VariationPopup.h"

#import "SearchSuggestion.h"
#import "RecentSearchHeaderView.h"
#import "RecentSearchCell.h"
#import "SearchSuggestionCell.h"

#import "SearchProduct.h"

#import "OFIconMapper.h"
#import "UITableView+Reuse.h"

#import "WishlistConnection.h"

#define kOmnitureWithlistSearchPageType @"search"

@interface WMBSearchView () <UITableViewDataSource, UITableViewDelegate, ProductCardCellDelegate, RecentSearchHeaderViewDelegate>

@property (strong, nonatomic) RecentSearchHeaderView *recentSearchHeaderView;

@end

@implementation WMBSearchView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wishlistDidChange:) name:kWishlistNotificationName object:nil];
    
    self.recentSearchHeaderView = [RecentSearchHeaderView new];
    _recentSearchHeaderView.delegate = self;
    
    [_suggestionsTableView registerClassForCellWithClass:[RecentSearchCell class]];
    [_suggestionsTableView registerClassForCellWithClass:[SearchSuggestionCell class]];
    _suggestionsTableView.delegate = self;
    _suggestionsTableView.dataSource = self;
    _suggestionsTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [_resultTableView registerNibForCellWithClass:[ProductCardCell class]];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    _resultTableView.tableHeaderView = [SearchResultHeaderView new];
    
    self.state = WMBSearchViewStateRecentSearch;
}

- (void)setState:(WMBSearchViewState)state {
    _suggestionsView.hidden = state != WMBSearchViewStateRecentSearch && state != WMBSearchViewStateSuggestion;
    _resultView.hidden = state != WMBSearchViewStateResult;
    
    if (state == WMBSearchViewStateLoading) {
        [self showLoading];
    }
    else if (_state == WMBSearchViewStateLoading) {
        [self hideLoading];
    }
    
    if (_state == WMBSearchViewStateError) {
        [self hideEmptyView];
    }
    
    _state = state;
    
    switch (state) {
        case WMBSearchViewStateRecentSearch:
            self.searchSuggestion = nil;
            break;
            
        default:
            break;
    }
    
    [_suggestionsTableView reloadData];
    [_resultTableView reloadData];
}

- (void)setRecentSearches:(NSArray *)recentSearches {
    _recentSearches = recentSearches;
    [_suggestionsTableView reloadData];
}

- (void)setProducts:(NSArray *)products {
    [self setEndReached:NO];
    _products = products;
    
    [_resultTableView reloadData];
}

- (void)setEndReached:(BOOL)endReached {
    if (endReached) {
        _resultTableView.tableFooterView = nil;
    }
    _endReached = endReached;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _suggestionsTableView) {
        return _state == WMBSearchViewStateRecentSearch ? 1 : 2;
    }
    else if (tableView == _resultTableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _suggestionsTableView) {
        if (_state == WMBSearchViewStateRecentSearch) {
            return _recentSearches.count;
        }
        else {
            return section == 0 ? _searchSuggestion.departments.count : _searchSuggestion.suggestions.count;
        }
    }
    else if (tableView == _resultTableView) {
        return _products.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _suggestionsTableView &&_state == WMBSearchViewStateRecentSearch) {
        return _recentSearchHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _state == WMBSearchViewStateRecentSearch ? _recentSearchHeaderView.bounds.size.height : 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _suggestionsTableView) {
        return 44.f;
    }
    else if (tableView == _resultTableView) {
        if (indexPath.row < self.products.count) {
            SearchProduct *product = _products[indexPath.row];
            
            return [product hasDiscount] ? 196.f : 197.f;
        }
        else {
            return 60.f;
        }
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _suggestionsTableView) {
        if (_state == WMBSearchViewStateRecentSearch) {
            RecentSearchCell *cell = [_suggestionsTableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecentSearchCell class]) forIndexPath:indexPath];
            cell.textLabel.text = [_recentSearches objectAtIndex:indexPath.row];
            return cell;
        }
        else {
            SearchSuggestionCell *cell = [_suggestionsTableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchSuggestionCell class]) forIndexPath:indexPath];
            if (indexPath.section == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ em %@", _searchSuggestion.suggestedTerm, _searchSuggestion.departments[indexPath.row]];
                cell.imageView.image = [UIImage imageNamed:[[OFIconMapper imageForCategoryName:_searchSuggestion.departments[indexPath.row]] valueForKey:@"normal"]];
                cell.imageView.highlightedImage = [UIImage imageNamed:[[OFIconMapper imageForCategoryName:_searchSuggestion.departments[indexPath.row]] valueForKey:@"pressed"]];
            }
            else {
                cell.textLabel.text = _searchSuggestion.suggestions [indexPath.row];
                cell.imageView.image = [UIImage imageNamed:@"UISearchQuote-Blue.png"];
                cell.imageView.highlightedImage = [UIImage imageNamed:@"UISearchQuote-White.png"];
            }
            return cell;
        }
    }
    else {
        ProductCardCell *cell = [tableView dequeueReusableCellWithClass:[ProductCardCell class]];
        cell.delegate = self;
        [cell setupWithSearchProduct:_products[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _resultTableView) {
        LogInfo(@"[BUSCA] endReached: %i", self.endReached);
        LogInfo(@"[BUSCA] i.p.row: %i | i.p.section.row: %i", (int)indexPath.row, (int)[tableView numberOfRowsInSection:indexPath.section]);
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1 && !self.endReached) {
            tableView.tableFooterView = _loadMoreView;
            [_loadMoreView startLoadingMore];
            if ([_delegate respondsToSelector:@selector(searchViewRequestedMoreProducts)]) {
                [_delegate searchViewRequestedMoreProducts];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _suggestionsTableView) {
        if (_state == WMBSearchViewStateRecentSearch) {
            if ([_delegate respondsToSelector:@selector(searchViewSelectedSuggestion:)]) {
                [_delegate searchViewSelectedSuggestion:[_recentSearches objectAtIndex:indexPath.row]];
            }
        }
        else {
            if (indexPath.section == 0) {
                if ([_delegate respondsToSelector:@selector(searchViewSelectedDepartmentWithName:)]) {
                    [_delegate searchViewSelectedDepartmentWithName:_searchSuggestion.departments[indexPath.row]];
                }
            }
            else if (indexPath.section == 1) {
                if (_delegate && [_delegate respondsToSelector:@selector(searchViewSelectedSuggestion:)]) {
                    [_delegate searchViewSelectedSuggestion:[_searchSuggestion.suggestions objectAtIndex:indexPath.row]];
                }
            }
        }
    }
    else if (tableView == _resultTableView) {
        if (indexPath.row < _products.count) {
            SearchProduct *product = [_products objectAtIndex:indexPath.row];
            if ([_delegate respondsToSelector:@selector(searchViewSelectedProduct:)]) {
                [_delegate searchViewSelectedProduct:product];
            }
        }
    }
}

#pragma mark - RecentSearchHeaderViewDelegate
- (void)recentSearchesHeaderViewPressedClearRecentSearches {
    if ([_delegate respondsToSelector:@selector(searchViewRequestedToClearRecentSearches)]) {
        [_delegate searchViewRequestedToClearRecentSearches];
    }
}

#pragma mark - ProductCardCellDelegate
- (void)tappedHeartButtonInProductCell:(id)cell {
    NSIndexPath *productIndexPath = [_resultTableView indexPathForCell:cell];
    if (productIndexPath && productIndexPath.row >= _products.count) return;
    
    SearchProduct *product = _products[productIndexPath.row];
    if (productIndexPath.row >= _products.count) return;
    
    if (product.hasSkuOptions.boolValue && !product.wishlist) {
        VariationPopup *variationPopup = [[VariationPopup alloc] initWithProductId:product.productId.stringValue selectedSKUBlock:^(NSNumber *sku) {
            product.favoriteSKU = sku;
            [self addProductToWishlist:product];
        }];
        
        [self addSubview:variationPopup];
    }
    else {
        product.wishlist ? [self removeProductFromWishlist:product] : [self addProductToWishlist:product];
    }
}

- (void)addProductToWishlist:(SearchProduct *)product {
    NSString *productId = product.productId.stringValue;
    NSNumber *favoriteSKU = product.favoriteSKU;
//    SearchProductVariation *variation = product.productVariations[0];
//    NSString *sellerId = variation.sellerId;
    NSString *sellerId = product.sellerId;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:product];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"searchHeart"];
    
    if (![WALSession isAuthenticated]) {
        if ([_delegate respondsToSelector:@selector(searchViewRequestedToPresentLoginWithSuccessBlock:)]) {
            [_delegate searchViewRequestedToPresentLoginWithSuccessBlock:^{
                [self addProductToWishlist:product];
            }];
        }
        return;
    }
    
    [self pulseHeart:YES forProduct:product];
    [[WishlistConnection new] addProductWithSKU:favoriteSKU.stringValue productID:productId sellerId:sellerId completion:^(BOOL success, NSError *error) {
        if (success) {
            product.wishlist = YES;
            [WMOmniture trackAddToWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistSearchPageType];
        }
        else {
            if (error.code == 400 || error.code == 401) {
                if ([self->_delegate respondsToSelector:@selector(searchViewRequestedToPresentLoginWithSuccessBlock:)]) {
                    [self->_delegate searchViewRequestedToPresentLoginWithSuccessBlock:^{
                        [self addProductToWishlist:product];
                    }];
                }
            }
            else if (error.code == 409) {
                product.wishlist = YES;
            }
            else if (error.code == 422) {
                [self showFeedbackAlertOfKind:ErrorAlert message:error.localizedDescription];
            }
        }
        [self pulseHeart:NO forProduct:product];
    }];
}

- (void)loginWithFacebook:(NSNotification *)notification {
    //Search by pre favorited product
    NSData *wishlistProductData = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchHeart"];
    if (wishlistProductData) {
        SearchProduct *spm = [NSKeyedUnarchiver unarchiveObjectWithData:wishlistProductData];
        [self addProductToWishlist:spm];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchHeart"];
    }
}

- (void)removeProductFromWishlist:(SearchProduct *)product {
    if (![WALSession isAuthenticated]) {
        if ([_delegate respondsToSelector:@selector(searchViewRequestedToPresentLoginWithSuccessBlock:)]) {
            [_delegate searchViewRequestedToPresentLoginWithSuccessBlock:^{
                [self removeProductFromWishlist:product];
            }];
        }
        return;
    }
    
    [self pulseHeart:YES forProduct:product];
    
    NSNumber *favoriteSKU = product.favoriteSKU;
    SearchProductVariation *variation = product.productVariations[0];
    NSString *sellerId = variation.sellerId;
    
    [[WishlistConnection new] removeProductWithSKU:favoriteSKU.stringValue productId:product.productId.stringValue completion:^(BOOL success, NSError *error) {
        if (success) {
            product.wishlist = NO;
            [WMOmniture trackRemoveFromWishlistWithSellerId:sellerId sku:favoriteSKU pageType:kOmnitureWithlistSearchPageType];
        }
        
        if (error.code == 400 || error.code == 401) {
            if ([self->_delegate respondsToSelector:@selector(searchViewRequestedToPresentLoginWithSuccessBlock:)]) {
                [self->_delegate searchViewRequestedToPresentLoginWithSuccessBlock:^{
                    [self removeProductFromWishlist:product];
                }];
            }
        }
        [self pulseHeart:NO forProduct:product];
    }];
}

- (void)pulseHeart:(BOOL)pulse forProduct:(SearchProduct *)product {
    product.isRefreshingWishlistStatus = pulse;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_products indexOfObject:product] inSection:0];
    ProductCardCell *cell = (ProductCardCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
    [cell updateHeartStatus];
}

#pragma mark - Sort
- (IBAction)orderResultsPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(searchViewRequestedToPresentSortOptions)]) {
        [_delegate searchViewRequestedToPresentSortOptions];
    }
}

#pragma mark - Filter
- (IBAction)filterResultsPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(searchViewRequestedToPresentFilter)]) {
        [_delegate searchViewRequestedToPresentFilter];
    }
}

#pragma mark - Wishlist Notification
- (void)wishlistDidChange:(NSNotification *)notification {
    NSDictionary *notificationDictionary = notification.object;
    NSArray *productsIds = notificationDictionary[@"productsIds"];
    BOOL wishlist = [notificationDictionary[@"wishlist"] boolValue];
    
    for (NSString *productId in productsIds) {
        for (NSInteger i = 0; i < _products.count; i++) {
            SearchProduct *product = _products[i];
            if ([product.productId.stringValue isEqualToString:productId]) {
                product.wishlist = wishlist;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_resultTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
                break;
            }
        }
    }
}

@end
