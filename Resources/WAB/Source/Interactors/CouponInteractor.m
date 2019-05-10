//
//  CouponInteractor.m
//  Walmart
//
//  Created by Renan Cargnin on 07/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "CouponInteractor.h"

@implementation CouponInteractor

+ (NSString *)maskedRedemptionCodeWithRedemptionCode:(NSString *)redemptionCode {
    return [NSString stringWithFormat:@"****%@", [redemptionCode substringFromIndex:redemptionCode.length >= 4 ? redemptionCode.length - 4 : 0]];
}

+ (NSString *)warningMessageForRemovedCoupons:(NSArray *)removedCoupons {
    BOOL plural = removedCoupons.count > 1;
    NSString *pluralString = plural ? @"s" : @"";
    NSString *cupomString = plural ? @"cupons" : @"cupom";
    NSString *wasWereString = plural ? @"foram" : @"foi";
    
    NSMutableString *warningMessage = [NSMutableString new];
    [warningMessage appendFormat:@"O%@ seguinte%@ %@ %@ excluído%@.", pluralString, pluralString, cupomString, wasWereString, pluralString];
    
    for (NSDictionary *coupon in removedCoupons) {
        [warningMessage appendFormat:@"\nCupom: %@", [[self class] maskedRedemptionCodeWithRedemptionCode:coupon[@"redemptionCode"]]];
    }
    
    return warningMessage.copy;
}

@end
