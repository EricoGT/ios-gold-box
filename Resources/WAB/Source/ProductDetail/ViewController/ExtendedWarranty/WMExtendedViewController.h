//
//  WMExtendedViewController.h
//  Walmart
//
//  Created by Marcelo Santos on 1/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"

#import "WMKnowMoreViewController.h"
#import "WMButton.h"

@class ProductDetailModel, WishlistProduct;

@interface WMExtendedViewController : WMBaseViewController

- (WMExtendedViewController *)initWithSKU:(NSNumber *)sku productDetail:(ProductDetailModel *)productDetail pressedBuyBlock:(void (^)(NSArray *warrantiesIds))pressedBuyBlock;
- (WMExtendedViewController *)initWithWishlistProduct:(WishlistProduct *)wishlistProduct baseImageURL:(NSString *)baseImageURL pressedBuyBlock:(void (^)(NSArray *warrantiesIds))pressedBuyBlock;

@property (nonatomic, strong) WMKnowMoreViewController *wk;

- (IBAction) buyProduct;

@end
