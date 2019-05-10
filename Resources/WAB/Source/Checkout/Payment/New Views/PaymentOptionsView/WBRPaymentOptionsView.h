//
//  WBRPaymentOptionsView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPaymentTypeCreditCard,
    kPaymentTypeBankingSlip
} kPaymentType;

@class WBRPaymentOptionsView;

@protocol WBRPaymentOptionsViewProtocol <NSObject>

/**
 The method is called when credit card option is selected

 @param paymentOptionsView
 @param page Page that the indicator will show
 */
- (void)WBRPaymentOptionsViewDidSelectCreditCard:(WBRPaymentOptionsView *)paymentOptionsView;

/**
 The method is called when banking slip is selected;

 @param paymentOptionsView
 @param page Page that the indicator will show
 */
- (void)WBRPaymentOptionsViewDidSelectBankingSlip:(WBRPaymentOptionsView *)paymentOptionsView;

@end

@interface WBRPaymentOptionsView : UIView

@property (weak, nonatomic) id <WBRPaymentOptionsViewProtocol> delegate;
@property (nonatomic) kPaymentType selectedPayment;
@property (strong, nonatomic, readonly) NSNumber *suggestedHeight;

- (void)setOnlyCreditCardOption:(BOOL)visible;

@end
