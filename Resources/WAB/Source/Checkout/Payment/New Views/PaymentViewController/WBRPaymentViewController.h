//
//  WBRPaymentViewController.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/25/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pay2Delegate <NSObject>
@optional
- (void) simplePayment;
- (void) closePayment;
- (void) closePaymentAndComeBack;
- (void) closePaymentAndComeBackToCart;
- (void) gotoAddressScreen;
- (void) gotoProductsScreen;
- (void) closePaymentFromSuccess;
- (void) closePaymentToCart;
@end

@interface WBRPaymentViewController : UIViewController

@property (weak) id <pay2Delegate> delegate;
@property (nonatomic, assign) BOOL splitedPayment;
@property (nonatomic, strong) NSDictionary *deliveries;
@property (nonatomic, strong) NSDictionary *fullAddress;
@property (nonatomic, assign) BOOL isSinglePaymentAndHasExtendedWarranty;

@end
