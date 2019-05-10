//
//  WMPaymentFormsTableViewCell.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/13/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaymentItem;
@class Installment;

@interface WMPaymentFormsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

+ (UINib *)nib;
- (void)setupWithInstallment:(Installment *)installment;
- (void)setupInCheckoutWithInstallment:(Installment *)installment;
- (void)setSelectedWithInstallment:(Installment *)installment;
- (void)setDeselectedWithInstallment:(Installment *)installment;

@end
