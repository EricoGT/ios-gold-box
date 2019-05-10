//
//  PaymentItem.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "Installment.h"
#import "PaymentType.h"

@protocol PaymentItem
@end

@interface PaymentItem : JSONModel

@property (nonatomic, strong) PaymentType *paymentType;
@property (nonatomic, strong) NSArray<Installment>*installments;
@property (nonatomic, assign) BOOL credit;
@property (nonatomic, strong) NSString<Optional> *rateMessage;
@property (nonatomic, strong) NSString<Optional> *maxCET;

@end
