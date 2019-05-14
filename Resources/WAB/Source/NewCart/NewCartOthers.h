//
//  NewCartOthers.h
//  Walmart
//
//  Created by Marcelo Santos on 5/20/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMButton.h"

#import "CouponSubmitView.h"
#import "WBRBestInstallment.h"

@class NewCartOthers;

@protocol NewCartOthersDelegate <NSObject>
@required
@optional
- (void)continueShopping;
- (void)showCalculateShipmentViewController;
- (void)showAddCouponViewController;
- (void)removeCouponWithRedemptionCode:(NSString *)redemptionCode;
@end

@interface NewCartOthers : WMView <UITextFieldDelegate>

@property (weak) id <NewCartOthersDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *viewOthers;
@property (weak, nonatomic) IBOutlet UIView *viewSubtotal;
@property (weak, nonatomic) IBOutlet UIView *viewFreight;
@property (weak, nonatomic) IBOutlet UIView *viewTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscountValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtotalTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtotalValue;
@property (weak, nonatomic) IBOutlet UILabel *lblFreightTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFreightValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalValue;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallment;

- (void)setCoupon:(NSDictionary *)coupon withNominalDiscount:(CGFloat)nominalDiscount;
- (void)setDiscountValue:(NSString *)discount;
- (void)setFreightPrice:(NSString *)price andPostalCode:(NSString *)postalCode;
- (void)setSubtotal:(float)subtotal itemsQty:(int)itemsQty;
- (void)setTotal:(float)total valuePerInstallment:(float)valuePerInstallment installmentQty:(int)installmentQty;

- (void)setupWithSubtotal:(float)subtotal
                 itemsQty:(int)itemsQty
               postalCode:(NSString *)postalCode
             freightPrice:(NSString *)freightPrice
                    total:(float)total
      valuePerInstallment:(float)valuePerInstallment
           installmentQty:(int)installmentQty
          bestInstallment:(WBRBestInstallment *)bestInstallment;

- (void) showMsgCouponRemoved:(NSString *) coupon;


@end
