//
//  ProductBuyView.h
//  Walmart
//
//  Created by Renan Cargnin on 1/26/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol ProductBuyViewDelegate <NSObject>
@required
- (void)productBuyPressedBuyButtonWithQuantity:(NSUInteger)quantity;
@end

@interface ProductBuyView : WMView

@property (weak) id <ProductBuyViewDelegate> delegate;

- (ProductBuyView *)initWithDelegate:(id <ProductBuyViewDelegate>)delegate;

- (NSUInteger)quantity;

@end
