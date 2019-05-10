//
//  ProductSellersView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductSellersViewDelegate <NSObject>
@required
- (void)productSellersBuyProductWithSellerId:(NSString *)sellerId;
@optional
- (void)productSellersDidTapWithSellerId:(NSString *)sellerId;
@end

@interface ProductSellersView : WMView

@property (weak) id <ProductSellersViewDelegate> delegate;

- (ProductSellersView *)initWithSellers:(NSArray *)sellers delegate:(id <ProductSellersViewDelegate>)delegate;
- (void)setSellers:(NSArray *)sellers;

@end
