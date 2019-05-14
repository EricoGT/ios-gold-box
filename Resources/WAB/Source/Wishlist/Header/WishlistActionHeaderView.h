//
//  WishlistActionHeaderView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/7/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol WishlistActionHeaderViewDelegate <NSObject>
@optional
- (void)wishlistActionHeaderTappedBack;
- (void)wishlistActionHeaderTappedAlreadyBought;
- (void)wishlistActionHeaderTappedRemove;
@end

@interface WishlistActionHeaderView : WMView

@property (weak) id <WishlistActionHeaderViewDelegate> delegate;

- (WishlistActionHeaderView *)initWithSuperview:(UIView *)superview selectedCount:(NSUInteger)selectedCount delegate:(id <WishlistActionHeaderViewDelegate>)delegate;

- (void)setSelectedCount:(NSUInteger)selectedCount;
- (void)setSuperview:(UIView *)superview;

- (void)show;
- (void)hideAnimated:(BOOL)animated;

- (void)hideAlreadyBoughtButton;
- (void)showAlreadyBoughtButton;

@end
