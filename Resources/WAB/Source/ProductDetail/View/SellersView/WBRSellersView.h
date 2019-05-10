//
//  WBRSellersView.h
//  Walmart
//
//  Created by Cássio Sousa on 20/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"
#import "SellerOptionModel.h"

@protocol WBRSellersViewDelegate <NSObject>

@required
- (void)selectSeller:(SellerOptionModel *)sellerOption;
- (void)productSellerNameDidTapWithSellerId:(NSString *)sellerId;
- (void)productSellerOtherPaymentDidTap:(SellerOptionModel *)sellerOption;
- (void)productSellerMoreFreightOptions;
@end

@interface WBRSellersView : WMView
- (void)setupSellers:(NSArray<SellerOptionModel> *) sellers;
- (SellerOptionModel *)getSellerSelected;
- (void)reloadCells;

@property (nonatomic, weak) id <WBRSellersViewDelegate> delegate;
@end
