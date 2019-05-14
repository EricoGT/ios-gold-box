//
//  PaymentForms.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "PaymentItem.h"
#import "Installment.h"

@interface PaymentForms : JSONModel

//@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSArray<PaymentItem>*payments;

@end
