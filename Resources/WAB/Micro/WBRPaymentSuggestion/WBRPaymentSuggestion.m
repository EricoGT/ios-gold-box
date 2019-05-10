//
//  WBRPaymentSuggestion.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 11/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentSuggestion.h"

@implementation WBRPaymentSuggestion

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"currentPrice": @"price.current",
                                                       @"discountedPrice": @"price.discountedPrice"
                                                       }];
}

- (BOOL)isBankSlip {
    if ([self.paymentMethod isEqualToString:@"BANK_SLIP"]) {
        return YES;
    }
    return NO;
}

- (void)setPaymentMethod:(NSString *)paymentMethod {
    _paymentMethod = paymentMethod;
    [self setPaymentMethodStringByPaymentMethod:paymentMethod];
}

- (void)setPaymentMethodStringByPaymentMethod:(NSString *)paymentMethod {
    if ([paymentMethod isEqualToString:@"BANK_SLIP"]) {
        self.paymentMethodString = @" no boleto";
    } else {
        self.paymentMethodString = @"";
    }
}

@end
