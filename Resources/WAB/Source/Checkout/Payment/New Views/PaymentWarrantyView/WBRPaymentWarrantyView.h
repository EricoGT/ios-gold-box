//
//  WBRPaymentWarrantyView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/1/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRWalletModel.h"
#import "WBRPaymentAddNewCardView.h"

@class WBRPaymentWarrantyView;

@protocol WBRPaymentWarrantyViewProtocol <NSObject>

- (void)WBRPaymentWarrantyView:(WBRPaymentWarrantyView *)paymentWarrantyView didUpdateContentHeight:(NSNumber *)newHeight;
- (void)WBRPaymentWarrantyViewDidReceiveInstallmentNotification:(WBRPaymentWarrantyView *)paymentWarrantyView;

- (void)WBRPaymentMethodsView:(WBRPaymentWarrantyView *)paymentMethodsView didSelectCard:(WBRCardModel *)card;

- (void)displayLoadingView;
- (void)hideLoadingView;

- (void)paymentMethodsShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;

/**
 *  Called uppon any kind of request error that may occur
 */
- (void)checkoutError:(NSString *)error backToCart:(BOOL)backToCart;

- (void)paymentMethodsPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell;

@end

@interface WBRPaymentWarrantyView : UIView

- (void)closePaymentOptions;
- (void)collapseContent;
- (void)fillInfoPaymentWithDictionary:(NSDictionary *) dictInfo;
- (BOOL)hasValidCard;
- (NSDictionary *)getContentPayment;
- (void)processInstallments:(NSString *)strPaymentWithCart;



- (CreditCardFlag)getCreditCardFlag;
- (NSString *)getCreditCardNumber;



@property (weak, nonatomic) id <WBRPaymentWarrantyViewProtocol> delegate;
@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;
@property (strong, nonatomic) NSDictionary *paymentDictionary;
@property (weak) NSString *cCardSelected;
@property (strong, nonatomic) WBRWalletModel *wallet;

@end
