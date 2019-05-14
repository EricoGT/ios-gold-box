//
//  WBRPaymentMethodsView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRPaymentAddNewCardView.h"

#import "CardIOPaymentViewControllerDelegate.h"
#import "PaymentPickerViewController.h"
#import "WBRWalletModel.h"

@class WBRPaymentMethodsView;

@protocol WBRPaymentMethodsViewProtocol <NSObject>
@optional
- (void)WBRPaymentMethodsView:(WBRPaymentMethodsView *)paymentMethodsView didUpdateContentHeight:(NSNumber *)newHeight;
- (void)WBRPaymentMethodsViewDidReceiveInstallmentNotification:(WBRPaymentMethodsView *)paymentWarrantyView;

- (void)WBRPaymentMethodsView:(WBRPaymentMethodsView *)paymentMethodsView didSelectCard:(WBRCardModel *)card;

/**
 *  Informs the parent view to display/hide loading indicators
 */
- (void)displayLoadingView;
- (void)hideLoadingView;

- (void)paymentMethodsShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;


/**
 *  Called uppon any kind of request error that may occur
 */
- (void)checkoutError:(NSString *)error backToCart:(BOOL)backToCart;

/**
 *  Called when the user changes the payment type. At this point, the app is calling the services
 *  to check wheter or not that payment option is available.
 *  Should be used to disable user interaction on parent views
 */
- (void)didChangePaymentMethod;

/**
 *  Called when the app is able to perform this payment type. If any error occurs during the request, this method will not be called.
 */
- (void)didChoosePaymentMethodCreditCard;

/**
 *  Called when the app is able to perform this payment type. If any error occurs, this will not be called.
 */
- (void)didChoosePaymentMethodCreditBankSlip;

- (void)paymentMethodsPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell;



#pragma mark - Legacy Protocol (payPickerDelegate)
- (void) updateValueInfos:(NSArray *) arrValues;
- (void) updateValueInfosTicket:(NSArray *) arrValues;
- (void) goCreditCards;
//- (void) cardPaymentCellPressedScanCardButton:(CardPaymentCell *)cardPaymentCell;
- (void) finishOrderWithCreditCard;
//- (void) cardPaymentCell:(CardPaymentCell *)cardPaymentCell DidUpdateHeight:(CGFloat)newHeight;

@end

@interface WBRPaymentMethodsView : UIView <UITextFieldDelegate, comboPickerDelegate> {
    
    BOOL isBankingTicket;
}

- (void)closePaymentOptions;
- (void)collapseContent;
- (void)fillInfoPaymentWithDictionary:(NSDictionary *) dictInfo;
- (BOOL)hasValidCard;
- (NSDictionary *)getContentPayment;
- (void)updatePaymentInformation;
- (void)setOnlyCreditCardOption:(BOOL)visible;
- (void)reloadContent;
- (void)clearCreditCardInputtedContent;

- (void)processInstallments:(NSString *)strPaymentWithCart;


- (NSString *)getCreditCardNumber;
- (CreditCardFlag)getCreditCardFlag;
- (NSInteger)getValueToDebit;




@property (weak, nonatomic) id <WBRPaymentMethodsViewProtocol> delegate;
@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;
@property (strong, nonatomic) NSDictionary *paymentDictionary;
@property (weak) NSString *cCardSelected;
@property (strong, nonatomic) WBRWalletModel *wallet;

@end
