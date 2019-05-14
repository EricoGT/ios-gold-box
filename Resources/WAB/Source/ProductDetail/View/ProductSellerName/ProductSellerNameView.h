//
//  ProductSellerNameView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@class SellerOptionModel;

@protocol ProductSellerNameViewDelegate <NSObject>
@optional
- (void)productSellerNameDidTapWithSellerId:(NSString *)sellerId;
@end

@interface ProductSellerNameView : WMView

@property (weak) id <ProductSellerNameViewDelegate> delegate;

- (ProductSellerNameView *)initWithSeller:(SellerOptionModel *)seller delegate:(id <ProductSellerNameViewDelegate>)delegate;

- (void)setSeller:(SellerOptionModel *)seller;

@end
