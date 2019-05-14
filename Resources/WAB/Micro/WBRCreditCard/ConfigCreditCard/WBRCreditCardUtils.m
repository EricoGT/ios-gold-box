//
//  WBRCreditCardConstants.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 11/09/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardUtils.h"


NSString * const kMastercardString = @"master";
NSString * const kHipercardString  = @"hiper";
NSString * const kAmexString       = @"amex";
NSString * const kVisaString       = @"visa";


@implementation WBRCreditCardUtils


+ (BOOL)isPaymentTypesEnableStamp:(NSArray *)paymentTypes {
    BOOL isEnableStamp = NO;
    
    if (paymentTypes.count == 1) {
        if ([paymentTypes[0] containsString:[kMastercardString uppercaseString]]) {
            isEnableStamp = YES;
        }
    } else {
        for (NSString *cardBrand in paymentTypes) {
            NSString *cardBrandCapitalized = [cardBrand uppercaseString];
            if (([cardBrandCapitalized containsString:[kMastercardString uppercaseString]]) || ([cardBrandCapitalized containsString:[kHipercardString uppercaseString]])) {
                isEnableStamp = YES;
            } else {
                isEnableStamp = NO;
                return isEnableStamp;
            }
        }
    }
    return isEnableStamp;
}

@end
