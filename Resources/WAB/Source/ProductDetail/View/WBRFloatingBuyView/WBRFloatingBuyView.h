//
//  WBRFloatingBuyView.h
//  Walmart
//
//  Created by Accurate Rio Preto on 19/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"
#import "SellerOptionModel.h"

@protocol WBRFloatingBuyViewDelegate <NSObject>
@required
- (void)floatingProductBuyPressedBuyButton:(NSString *)sellerId;
@end

@interface WBRFloatingBuyView : WMView
@property (nonatomic, weak) id <WBRFloatingBuyViewDelegate> delegate;

- (void)setupWithSellerOption:(SellerOptionModel *)sellerOption;
@property (strong, nonatomic) SellerOptionModel *sellerOption;
@end
