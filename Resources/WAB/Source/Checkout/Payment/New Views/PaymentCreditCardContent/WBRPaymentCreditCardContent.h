//
//  WBRPaymentCreditCardContent.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRPaymentAddNewCardView.h"

#import "WBRWalletModel.h"

typedef enum : NSUInteger {
    kPaymentCreditCardStateSelectingAddedCard,
    kPaymentCreditCardStateAddingNewCard
} kPaymentCreditCardState;

@class WBRPaymentCreditCardContent;

@protocol WBRPaymentCreditCardContentProtocol <NSObject>

- (void)WBRPaymentCreditCardContent:(WBRPaymentCreditCardContent *)paymentCreditCardContent didUpdateHeight:(NSNumber *)newHeight;
- (void)WBRPaymentCreditCardContent:(WBRPaymentCreditCardContent *)paymentCreditCardContent didSelectCard:(WBRCardModel *)card;

- (void)paymentCreditCardContentOpenPaymentOptions;
- (void)paymentCreditCardContentShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;
- (void)paymentCreditCardContentCallInstallments;
- (void)paymentCreditCardContentPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell;

@end


@interface WBRPaymentCreditCardContent : UIView

- (void)collapseContent;
- (void)setCardContainerLabelText:(NSString *)titleText;
- (void)clearSelectedInstallment;
- (void)setPaymentNumber:(NSString *)paymentNumber;
- (void)setCreditCardNumberInvalidLayout:(BOOL)invalid;
- (void)setInstallmentText:(NSString *)installmentText;
- (void)setHasProduct:(BOOL)hasProduct;
- (void)setHasExtendedWarranty:(BOOL)hasExtendedWarranty;

- (NSDictionary *)getContentPayment;
- (NSString *)getCreditCardNumber;
- (NSString *)getSelectedInstallmentText;
- (CreditCardFlag)getCreditCardFlag;

- (void)resignFirstResponderCreditCardNumberField;

- (NSString *)getNameCardWithNumber:(NSString *)cardNumber;
- (void)setRateLabel:(NSString *)rateText;
- (void)hideRateLabelAnimated:(BOOL)animated;
- (void)clearCreditCardInputtedContent;
- (void)resetCardsState;

@property (nonatomic) kPaymentCreditCardState currentState;

@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;
@property (strong, nonatomic) WBRWalletModel *wallet;

@property (weak, nonatomic) id <WBRPaymentCreditCardContentProtocol> delegate;

@end
