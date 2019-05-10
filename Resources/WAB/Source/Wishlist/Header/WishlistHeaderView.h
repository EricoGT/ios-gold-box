//
//  WishlistHeaderView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/7/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

typedef enum : NSUInteger {
    WishlistFilterOptionDidNotBuy = 0,
    WishlistFilterOptionAlreadyBought = 1
} WishlistFilterOption;

typedef enum : NSUInteger {
    WishlistSortOptionMostRecents = 0,
    WishlistSortOptionOlder = 1,
    WishlistSortOptionCheapest = 2,
    WishlistSortOptionMostExpensive = 3
} WishlistSortOption;

@protocol WishlistHeaderViewDelegate <NSObject>
@optional
- (void)wishlistHeaderViewDidSelectFilterOption:(WishlistFilterOption)viewOption;
- (void)wishlistHeaderViewDidSelectSortOption:(WishlistSortOption)sortOption;
@end

@interface WishlistHeaderView : WMView

@property (weak) id <WishlistHeaderViewDelegate> delegate;

- (WishlistHeaderView *)initWithTotalItems:(NSUInteger)totalItems delegate:(id)delegate;

- (void)setupUserNameLabel;
- (void)setTotalItems:(NSUInteger)totalItems;

- (WishlistFilterOption)selectedFilter;
- (WishlistSortOption)selectedSort;
- (NSString *)selectedFilterForOmniture;

@end
