//
//  WBRPaymentCreditCardTableView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRCardModel.h"
#import "WBRPaymentCreditCardContent.h"

@class WBRPaymentCreditCardTableView;

@protocol WBRPaymentCreditCardTableViewProtocol <NSObject>

- (void)WBRPaymentCreditCardTableView:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView didUpdateContentHeight:(NSNumber *)newHeight;
- (void)WBRPaymentCreditCardTableViewDidSelectInstallmentsOption:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView;
- (void)WBRPaymentCreditCardTableView:(WBRPaymentCreditCardTableView *)paymentCreditCardTableView didSelectCard:(WBRCardModel *)card;

@end

@interface WBRPaymentCreditCardTableView : UIView

@property (weak, nonatomic) id <WBRPaymentCreditCardTableViewProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITableView *creditCardsTableView;

@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;
@property (strong, nonatomic, readonly) WBRCardModel *selectedCard;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray<WBRCardModel *> *contentArray;

@property (weak) NSString *paymentNumber;

- (void)setRateText:(NSString *)rateText;
- (void)setInstallmentText:(NSString *)installmentText;
- (NSDictionary *)getContentPayment;
- (void)setContentArray:(NSArray<WBRCardModel *> *)contentArray currentState:(kPaymentCreditCardState)currentState;

@end
