//
//  Installment.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol Installment
@end


@interface Installment : JSONModel

//Payment forms only
@property (nonatomic, strong) NSString<Optional> *currency;
@property (nonatomic, strong) NSNumber<Optional> *price;
@property (nonatomic, strong) NSNumber<Optional> *instalment;
@property (nonatomic, strong) NSNumber<Optional> *instalmentValue;
@property (nonatomic, strong) NSString<Optional> *formattedPrice;

//Checkout only
@property (nonatomic, strong) NSNumber<Optional> *installmentAmount;
@property (nonatomic, strong) NSNumber<Optional> *valuePerInstallment;
@property (nonatomic, strong) NSNumber<Optional> *valuePerInstallmentCents;

//Checkout and payment forms
@property (nonatomic, strong) NSString<Optional> *formattedValuePerInstallment;
@property (nonatomic, strong) NSNumber<Optional> *rate;
@property (nonatomic, strong) NSNumber<Optional> *priceWithRate;

- (NSString *)formattedMessageWithRate;
- (NSString *)formattedMessageWithRateForCheckout;
- (NSString *)getInstallments;
- (NSString *)getInstallmentValue;
- (NSString *)getRateText;

@end
