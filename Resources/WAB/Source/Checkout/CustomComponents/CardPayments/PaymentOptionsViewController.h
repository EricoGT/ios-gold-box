//
//  PaymentOptionsViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 9/29/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Installment;

@protocol PaymentOptionsViewControllerDelegate <NSObject>
@required
- (void) closePaymentOptions;
- (void) paymentOptionSelected:(Installment *)installment index:(NSUInteger)index;
@end

@interface PaymentOptionsViewController : WMBaseViewController
@property (nonatomic, assign) id<PaymentOptionsViewControllerDelegate> delegate;

- (instancetype)initWithInstallments:(NSArray *)installments selectedIndex:(NSUInteger)index;

@end
