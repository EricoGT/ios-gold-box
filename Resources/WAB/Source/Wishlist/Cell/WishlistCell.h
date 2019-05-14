//
//  WishlistCell.h
//  Walmart
//
//  Created by Bruno Delgado on 12/4/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishlistProduct.h"

typedef enum : NSInteger {
    WishlistProductStatusPriceLow = -1
} WishlistProductStatusPrice;

@protocol WishlistCellDelegate <NSObject>
- (void)didTapSellerName:(NSString *)sellerId;
- (void)didTapWishlistProduct:(NSString *)productId;
- (void)didTapAddToCart:(WishlistProduct *)product;
- (void)wishlistCellDidSelectProduct:(WishlistProduct *)product;
- (void)wishlistCellDidDeselectProduct:(WishlistProduct *)product;
@end

@interface WishlistCell : UITableViewCell

@property (nonatomic, assign) id<WishlistCellDelegate> delegate;

- (CGFloat)heightForProduct:(WishlistProduct *)product;
- (void)setupWithProduct:(WishlistProduct *)product baseImagePath:(NSString *)baseImagePath;
+ (UINib *)nib;

@end
