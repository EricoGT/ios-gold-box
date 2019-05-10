//
//  ProductPriceView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@class SellerOptionModel;

@interface ProductPriceView : WMView

- (ProductPriceView *)initWithSellerOption:(SellerOptionModel *)sellerOption;
- (void)setupWithSellerOption:(SellerOptionModel *)sellerOption;

@end
