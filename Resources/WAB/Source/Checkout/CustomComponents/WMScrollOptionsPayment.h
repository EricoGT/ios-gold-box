//
//  WMScrollOptionsPayment.h
//  Walmart
//
//  Created by Marcelo Santos on 6/18/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrPaymentDelegate <NSObject>
@optional
- (void) goCreditCards;
- (void) goBankingTicket;
@end

@interface WMScrollOptionsPayment : WMBaseViewController

@property (weak) id <scrPaymentDelegate> delegate;

@property (assign, nonatomic) BOOL isAlreadyCards;
@property (assign, nonatomic) BOOL isAlreadyTicket;

- (void) changeColorBankingTicket;
- (void) changeColorCards;

- (void)moveToCreditCards:(id)sender;
- (void)moveToBankingTicket:(id)sender;

- (void) disableBankingOption;
- (void) disableBankingOptionInDouble;

- (void) moveBarToCardsWhenError;

@end
