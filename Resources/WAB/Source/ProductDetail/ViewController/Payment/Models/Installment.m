//
//  Installment.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "Installment.h"
#import "OFFormatter.h"

@implementation Installment

- (NSString *)formattedMessageWithRate {
    
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    NSString *installments = (self.instalment) ? [NSString stringWithFormat:@"%02d", (int)self.instalment.integerValue] : @"";
    NSString *installmentValue = (self.instalmentValue) ? [formatter stringFromNumber:self.instalmentValue] : @"";
    NSString *rateText = @"";

    if (self.rate) {
        CGFloat rate = self.rate.floatValue;
        if (rate > 0) {
            rateText = [NSString stringWithFormat:@"com juros (%@%% a.m.)", self.rate.stringValue];
        }
    }
    
    return [NSString stringWithFormat:@"%@x de %@\n%@", installments, installmentValue, rateText];
}

- (NSString *)formattedMessageWithRateForCheckout {
    
    LogInfo(@"Rate Test: %@ [%@]", self.rate.stringValue, self.priceWithRate.stringValue);
    
    if (_priceWithRate.floatValue == 0) {
        
        float valueNoInt = [[[NSUserDefaults standardUserDefaults] stringForKey:@"valueNoInterest"] floatValue];
        self.priceWithRate = [NSNumber numberWithFloat:valueNoInt];
    }
    
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    
    NSString *installments = [NSString stringWithFormat:@"%02d", (int)self.installmentAmount.integerValue] ?: @"";
    
//    NSString *installments = (self.installmentAmount) ? [self.installmentAmount stringValue] : @"";
    
    NSString *installmentValue = (self.valuePerInstallment) ? [formatter stringFromNumber:self.valuePerInstallment] : @"";
    
    
    NSString *rateText = @"";
    if (self.rate) {
        CGFloat rate = self.rate.floatValue;
        if (rate > 0) {
            
            NSString *strRate = [NSString stringWithFormat:@"%.2f", (float)self.rate.floatValue];
            rateText = [NSString stringWithFormat:@"com juros (%@%% a.m.)", strRate];
            
//            rateText = [NSString stringWithFormat:@"com juros (%@%% a.m.)", self.rate.stringValue];
        }
    }
    
    return [NSString stringWithFormat:@"%@x de %@\n%@", installments, installmentValue, rateText];
}

- (NSString *)getInstallments {
    NSString *installments = [NSString stringWithFormat:@"%02d", (int)self.installmentAmount.integerValue] ?: @"";
    return [NSString stringWithFormat:@"%@x de ", installments];
}

- (NSString *)getInstallmentValue {
    NSNumberFormatter *formatter = [[OFFormatter sharedInstance] currencyFormatter];
    return (self.valuePerInstallment) ? [formatter stringFromNumber:self.valuePerInstallment] : @"";
}

- (NSString *)getRateText {
    NSString *rateText = @"";
    if (self.rate) {
        CGFloat rate = self.rate.floatValue;
        if (rate > 0) {
            
            NSString *strRate = [NSString stringWithFormat:@"%.2f", (float)self.rate.floatValue];
            rateText = [NSString stringWithFormat:@"com juros (%@%% a.m.)", strRate];
            
            //            rateText = [NSString stringWithFormat:@"com juros (%@%% a.m.)", self.rate.stringValue];
        }
    }
    
    return rateText;
}

@end
