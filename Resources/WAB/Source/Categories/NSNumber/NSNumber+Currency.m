//
//  NSNumber+Currency.m
//  Walmart
//
//  Created by Renan Cargnin on 1/13/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "NSNumber+Currency.h"

@implementation NSNumber (Currency)

+ (NSString *)defaultCurrencySymbol {
    return @"R$ ";
}

+ (NSString *)currencyFormatWithIntValue:(int)intValue {
    return [@(intValue) currencyFormat];
}

+ (NSString *)currencyFormatWithIntegerValue:(NSInteger)integerValue {
    return [@(integerValue) currencyFormat];
}

+ (NSString *)currencyFormatWithFloatValue:(float)floatValue {
    return [@(floatValue) currencyFormat];
}

+ (NSString *)currencyFormatWithDoubleValue:(float)doubleValue {
    return [@(doubleValue) currencyFormat];
}

- (NSString *)currencyFormatWithCurrencySymbol:(NSString *)currencySymbol {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:currencySymbol];
    
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)currencyFormat {
    return [self currencyFormatWithCurrencySymbol:[NSNumber defaultCurrencySymbol]];
}

@end
