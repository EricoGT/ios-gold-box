//
//  WMBankSlipSuccessCard.h
//  Walmart
//
//  Created by Marcelo Santos on 6/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bankingSlipDelegate <NSObject>

- (void) updateSuccessBankingValue;
- (void) getBankingSlip;
- (void) sendMailToUser;

@end

@interface WMBankSlipSuccessCard : WMBaseViewController

@property (weak) id <bankingSlipDelegate> delegate;

- (IBAction)getBankSlip:(id)sender;
- (IBAction)sendMailToUser:(id)sender;
- (void) fillValue:(float) valueLabel;

@end
