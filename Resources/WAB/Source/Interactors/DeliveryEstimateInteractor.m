//
//  DeliveryEstimateInteractor.m
//  Walmart
//
//  Created by Renan Cargnin on 25/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "DeliveryEstimateInteractor.h"

@implementation DeliveryEstimateInteractor

+ (NSString *)deliveryEstimateWithDays:(NSUInteger)days unit:(NSString *)unit {
    if (days == 0) {
        return DELIVERY_SAME_DAY;
    }
    else {
        NSString *pluralString = days > 1 ? @"s" : @"";
        NSMutableString *deliveryEstimateString = [NSMutableString new];
        [deliveryEstimateString appendFormat:@"Em até %ld dia%@", (unsigned long) days, pluralString];
        if ([unit isEqualToString:@"bd"]) {
            [deliveryEstimateString appendString:days > 1 ? @" úteis" : @" útil"];
        }
        return deliveryEstimateString.copy;
    }
}

@end
