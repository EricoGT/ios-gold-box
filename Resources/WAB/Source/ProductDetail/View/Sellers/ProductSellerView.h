//
//  ProductSellerView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@class SellerOptionModel;

@protocol ProductSellerViewDelegate <NSObject>
@required
- (void)productSellerPressedCartWithSeller:(SellerOptionModel *)seller;
@optional
- (void)productSellerDidTapWithSellerId:(NSString *)sellerId;
@end

@class WMButton;

@interface ProductSellerView : WMView

@property (weak) id <ProductSellerViewDelegate> delegate;

- (ProductSellerView *)initWithSeller:(SellerOptionModel *)seller delegate:(id <ProductSellerViewDelegate>)delegate;

- (void)setSeller:(SellerOptionModel *)seller;

@end
