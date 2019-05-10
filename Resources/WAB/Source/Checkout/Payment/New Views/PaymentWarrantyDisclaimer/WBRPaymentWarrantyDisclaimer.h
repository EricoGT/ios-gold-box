//
//  WBRPaymentWarrantyDisclaimer.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/27/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBRPaymentWarrantyDisclaimer;

@protocol WBRPaymentWarrantyDisclaimerProtocol <NSObject>

- (void)WBRPaymentWarrantySelectedSinglePayment:(WBRPaymentWarrantyDisclaimer *)paymentWarrantyDisclaimer;

@end

@interface WBRPaymentWarrantyDisclaimer : UIView

@property (weak, nonatomic) id <WBRPaymentWarrantyDisclaimerProtocol> delegate;
@property (weak, nonatomic, readonly) NSNumber *suggestedHeight;

@end
