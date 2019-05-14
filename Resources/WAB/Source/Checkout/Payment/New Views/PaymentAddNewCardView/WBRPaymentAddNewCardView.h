//
//  WBRPaymentAddNewCardView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/30/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFloatLabelMaskedTextField.h"
#import "CreditCardInteractor.h"
#import "CardIOPaymentViewController.h"
#import "CardIOCreditCardInfo.h"

typedef enum : NSUInteger {
    kAddNewCardStateShowingAddButton,
    kAddNewCardStateShowingForm
} kAddNewCardState;

@class WBRPaymentAddNewCardView;

@protocol WBRPaymentAddNewCardViewProtocol <NSObject>

- (void)WBRPaymnetAddNewCardView:(WBRPaymentAddNewCardView *)paymentAddNewCardView didUpdateContentHeight:(NSNumber *)newHeight;


- (void)paymentAddNewCardViewShowFeedbackAlertOfKind:(FeedbackAlertKind)kind message:(NSString *)message;
- (void)paymentAddNewCardViewOpenPaymentOptions;
- (void)paymentAddNewCardViewCallInstallments;
- (void)paymentAddNewCardViewPressedScanCardButton:(WBRPaymentAddNewCardView *)cardPaymentCell;

@end

@interface WBRPaymentAddNewCardView : UIView <CardIOPaymentViewControllerDelegate>

- (void)showAddForm:(BOOL)shouldShow;
- (void)collapseContent;
- (NSDictionary *)getContentPayment;
- (NSString *) getNameCardWithNumber:(NSString *) cardNumber;
- (void)setRateTextLabel:(NSString *)rateText;
- (void)hideRateLabelAnimated:(BOOL)animated;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)resetContentValues;

@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardNumber;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardName;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardCvv;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *creditCardExpirationDate;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *installmentSelectedTextField;
@property (weak, nonatomic) IBOutlet WMFloatLabelMaskedTextField *clientDocument;

@property (weak, nonatomic) id <WBRPaymentAddNewCardViewProtocol> delegate;
@property (nonatomic) kAddNewCardState currentState;
@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;

@property (nonatomic, assign) CreditCardFlag creditCardFlag;

//@property (strong, nonatomic) NSArray *installments;
@property (weak) NSString *cCardSelected;
@property (weak) NSString *paymentNumber;

//Omniture helper properties
@property (assign, nonatomic) BOOL hasProduct;
@property (assign, nonatomic) BOOL hasExtendedWarranty;

@property (nonatomic) BOOL shouldHideSaveCard;
@property (nonatomic) BOOL shouldShowTitle;

@end
