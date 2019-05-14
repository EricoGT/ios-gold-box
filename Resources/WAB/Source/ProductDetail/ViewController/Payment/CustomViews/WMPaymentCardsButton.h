//
//  WMPaymentCardsButton.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentType.h"

@interface WMPaymentCardsButton : UIButton

@property (nonatomic, strong) PaymentType *paymentType;

- (id)initWithFrame:(CGRect)frame image:(NSString*)imageName paymentType:(PaymentType *)type;
- (id)initWithFrame:(CGRect)frame AndImage:(NSString*)imageName;

@end
