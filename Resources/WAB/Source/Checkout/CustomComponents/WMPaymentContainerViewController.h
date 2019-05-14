//
//  WMPaymentContainerViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 5/5/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMBaseViewController.h"
#import "CardPaymentCell.h"

@protocol WMPaymentContainerViewControllerDelegate <NSObject>
@optional
- (void)didUpdateContainerHeight:(CGFloat)newHeight;
- (void)didUpdatePaymentResumeInformation:(NSArray *)arrValues;
- (void)paymentCardPressedScanCardButton:(CardPaymentCell *)cardPaymentCell;
- (void)finishOrder;
@end

@interface WMPaymentContainerViewController : WMBaseViewController

@property (nonatomic, weak) id<WMPaymentContainerViewControllerDelegate> delegate;
@property (nonatomic, strong) CardPaymentCell *firstCardPayment;
@property (nonatomic, strong) CardPaymentCell *secondCardPayment;

@property (nonatomic, strong) NSDictionary *paymentDictionary;
@property (nonatomic, assign) BOOL payingWithTwoCards;
@property (nonatomic, assign) BOOL isSinglePaymentAndHasExtendedWarranty;
@property (nonatomic, assign) BOOL creditCardSelected;

- (BOOL)isPayingWithCreditCard;

- (void)reloadValuesWithPaymentDictionary:(NSDictionary *)paymentDictionary;

@end
