//
//  JSONValueTransformer+CustomDate.m
//  Tracking
//
//  Created by Bruno Delgado on 5/9/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "JSONValueTransformer+NSDate.h"

@implementation JSONValueTransformer (CustomDate)

- (NSDate *)NSDateFromNSNumber:(NSNumber *)number
{
    if (number)
    {
        if (number.integerValue == 0)
        {
            return nil;
        }
        
        double unixTimeEstimateDate = number.doubleValue;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeEstimateDate/1000];
        return date;
    }
    
    return nil;
}

- (NSDate *)NSDateFromNSString:(NSString *)string
{
    if (string)
    {
        if (string.integerValue == 0)
        {
            return nil;
        }
        
        double unixTimeEstimateDate = string.doubleValue;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeEstimateDate/1000];
        return date;
    }
    
    return nil;
}

- (NSNumber *)JSONObjectFromNSDate:(NSDate *)date
{
    NSNumber *number = @([NSDate timeIntervalSinceReferenceDate]*1000);
    return number;
}
//
//- (NSDate *)NSDateFromNSStringUsingDataDetector:(NSString *)date {
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mmZZZ"];
//
//    NSDate *utcDate = [dateFormatter dateFromString:date];
//
//    NSInteger secondsFromGMT = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:utcDate];
//
//    NSDate *timeZonedDate = [NSDate dateWithTimeInterval:secondsFromGMT sinceDate:utcDate];
//
//    return timeZonedDate;
//}

@end
