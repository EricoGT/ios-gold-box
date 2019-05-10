//
//  CardPaymentCell.h
//  CustomComponents
//
//  Created by Marcelo Santos on 2/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentPickerViewController.h"
#import "WMBaseViewController.h"

#import "CardIOPaymentViewControllerDelegate.h"

@class CardPaymentCell;

@protocol payPickerDelegate <NSObject>
@required
//- (void) setPaymentNumber:(NSString *) viewNumber andTextField:(UITextField *) textField andPosition:(NSInteger) fieldTag;
- (void) updateValueInfos:(NSArray *) arrValues;
- (void) updateValueInfosTicket:(NSArray *) arrValues;
- (void) goCreditCards;
- (void) checkoutError:(NSString *)error backToCart:(BOOL)backToCart;
- (void) cardPaymentCellPressedScanCardButton:(CardPaymentCell *)cardPaymentCell;
- (void) finishOrderWithCreditCard;
- (void) cardPaymentCell:(CardPaymentCell *)cardPaymentCell DidUpdateHeight:(CGFloat)newHeight;
@end

@interface CardPaymentCell : WMBaseViewController <UITextFieldDelegate, comboPickerDelegate, CardIOPaymentViewControllerDelegate> {
    
    __weak id <payPickerDelegate> delegate;
    BOOL isBankingTicket;
}


- (NSDictionary *) getContentPayment;

@property (weak) id delegate;
@property (nonatomic) BOOL isBankingTicket;
@property (nonatomic, assign) BOOL hideFinishOrderButton;

//Omniture helper properties
@property (assign, nonatomic) BOOL hasProduct;
@property (assign, nonatomic) BOOL hasExtendedWarranty;

- (void) fillInfoPaymentWithDictionary:(NSDictionary *) dictInfo;
- (void) fillScrollCreditCardsWithContent:(NSArray *) arrCreditCards;

- (IBAction) configMonthCard:(id)sender;
- (IBAction) configYearCard:(id)sender;
- (IBAction) configInstallments:(id)sender;

- (IBAction) hideKeyboardCard;

- (void) deselectAllCreditCards;
- (void) selectCreditCard:(id)sender;

- (void) getInstalls:(NSDictionary *) dictTicket;

- (NSString *) getNameCardWithNumber:(NSString *) cardNumber;

- (IBAction) resetCreditCardNumber;
- (void)callInstallments;
- (void) callInstallmentsBankingTicket;
- (BOOL)hasValidCard;

@end
