//
//  WBRSellersTableViewCell.h
//  Walmart
//
//  Created by Cássio Sousa on 20/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerOptionModel.h"

@protocol WBRSellersTableViewCellDelegate <NSObject>

@required
- (void)productSellerNameDidTapWithSellerId:(NSString *)sellerId;
- (void)productSellerOtherPaymentTap:(SellerOptionModel *)sellerOption;
- (void)productSellerMoreOptionsFreightTap;
@end

@interface WBRSellersTableViewCell : UITableViewCell
- (void)setupWithSellerOption:(SellerOptionModel *)sellerOption;
- (void)hideRadioButton;
- (void)hideSeparator;

@property (nonatomic, weak) id <WBRSellersTableViewCellDelegate> delegate;
@end
