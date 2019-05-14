//
//  WMBDiscountCouponViewController.h
//  Walmart
//
//  Created by Rafael Valim on 13/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscountCouponProtocol <NSObject>
@required
- (void)didApplyDiscountCouponToOrder;
- (void)didDismissCouponViewController;
@end

@interface WMBDiscountCouponViewController : UIViewController <UITextFieldDelegate>

@property (weak) id <DiscountCouponProtocol> delegate;
@property (nonatomic, assign) BOOL isCheckoutFlow;

@end

