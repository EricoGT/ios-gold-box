//
//  DeliveryType.m
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DeliveryType.h"
#import "OFFormatter.h"

@implementation DeliveryType

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"deliveryTypeID" : @"id"}];
}

- (BOOL)isConcierge
{
    if (!self.deliveryTypeID) return NO;
    return (self.deliveryTypeID.integerValue == ShippingTypeConcierge);
}

- (BOOL)isScheduledShipping
{
    if (!self.deliveryTypeID) return NO;
    return (self.deliveryTypeID.integerValue == ShippingTypeScheduled);
}

- (NSString *)shippingEstimate
{
    NSString *estimate;
    if ([self isScheduledShipping])
    {
        estimate = @"Agendada";
    }
    else
    {
        if (self.shippingEstimateInDays)
        {
            if ([self.shippingEstimateTimeUnit isEqualToString:@"bd"])
            {
                NSInteger days = self.shippingEstimateInDays.integerValue;
                switch (days) {
                    case 0:
                        estimate = DELIVERY_SAME_DAY;
                        break;
                        
                    case 1:
                        estimate = @"Em até 1 dia útil";
                        break;
                        
                    default:
                        estimate = [NSString stringWithFormat:@"Em até %ld dias úteis", (long)days];
                        break;
                }
            }
            else
            {
                NSInteger days = self.shippingEstimateInDays.integerValue;
                switch (days) {
                    case 0:
                        estimate = DELIVERY_SAME_DAY;
                        break;
                        
                    case 1:
                        estimate = @"Em até 1 dia";
                        break;
                        
                    default:
                        estimate = [NSString stringWithFormat:@"Em até %ld dias", (long)days];
                        break;
                }
            }
        }
        else
        {
            estimate = @"Não informado";
        }
    }
    return estimate;
}

- (NSString *)deliveryPrice
{
    NSString *formattedPrice = @"";
    NSNumber *formattedPriceNumber = nil;

    if (self.priceMap)
    {
        NSNumber *priceNumber = [self.priceMap objectForKey:self.deliveryTypeID];
        if (priceNumber)
        {
            double doublePrice = priceNumber.doubleValue;
            formattedPriceNumber = [NSNumber numberWithDouble:doublePrice/100];
        }
    }
    
    if (formattedPriceNumber)
    {
        if (formattedPriceNumber.doubleValue == 0)
        {
            formattedPrice = SHIPMENT_VALUE_FREE;
        }
        else
        {
            formattedPrice = [[[OFFormatter new] currencyFormatter] stringFromNumber:formattedPriceNumber];
        }
    }
    
    return formattedPrice;
}

- (NSString *)selectedScheduledDeliveryFormattedString {
    if (!_selectedScheduledDeliveryPeriod) return nil;
        
    NSString *period = _selectedScheduledDeliveryPeriod[@"period"];
    NSString *periodString = @"";
    
    if ([period isEqualToString:@"MORNING"])
    {
        periodString = @"Manhã";
    }
    else if([period isEqualToString:@"AFTERNOON"])
    {
        periodString = @"Tarde";
    }
    else if ([period isEqualToString:@"EVENING"])
    {
        periodString = @"Noite";
    }
    
    NSNumber *startUTCTime = _selectedScheduledDeliveryPeriod[@"startDateUtc"];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:(startUTCTime.doubleValue) / 1000.0];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [NSString stringWithFormat:@"%@ - Período: %@", [dateFormatter stringFromDate:startDate], periodString];
}

@end
