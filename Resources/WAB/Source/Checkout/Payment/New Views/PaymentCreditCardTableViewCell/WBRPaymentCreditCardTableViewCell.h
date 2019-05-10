//
//  WBRPaymentCreditCardTableViewCell.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRCardModel.h"

@class WBRPaymentCreditCardTableViewCell;

static NSString *kCreditCardCellIdentifier = @"kPaymentCreditCardTableViewCellIdentifier";
static NSInteger kCreditCardCellCollapsedHeight = 89;
static NSInteger kCreditCardCellExpandedHeight = 276;
static NSInteger kCreditCardCellExpandedWithRateWarningHeight = 335;

@protocol WBRPaymentCreditCardTableViewCellProtocol <NSObject>

- (void)WBRPaymentCreditCardTableViewCellDidSelectInstallmentOptions:(WBRPaymentCreditCardTableViewCell *)cell;

@end

@interface WBRPaymentCreditCardTableViewCell : UITableViewCell

@property (strong, nonatomic) WBRCardModel *card;
@property (nonatomic) BOOL showingRateWarning;
@property (weak, nonatomic) id <WBRPaymentCreditCardTableViewCellProtocol> delegate;
@property (weak) NSString *paymentNumber;

- (void)setInstallmentText:(NSString *)selectedInstallment;
- (NSString *)securityValue;
- (NSString *)selectedInstallment;
- (void)setRateLabelText:(NSString *)text;
- (void)resetState;
- (BOOL)checkFilledInformation;

@end
