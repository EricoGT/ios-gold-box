//
//  WMBSession.m
//  Walmart
//
//  Created by Bruno Delgado on 7/22/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBSession.h"
#import "FXKeychain.h"

static NSString *const SERVER_DATE_KEY = @"kServerDateKey";

@implementation WMBSession

+ (void)updateServerDateWithStringDate:(NSString *)serverDateInString
{
    if (serverDateInString.length > 0)
    {
        LogInfo(@"WMBSession updateServerDateWithStringDate: NSString %@", serverDateInString);
        NSDateFormatter *serverDateFormatter = [NSDateFormatter new];
        serverDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        serverDateFormatter.dateFormat = @"E, d MMM yyyy HH:mm:ss Z";
        serverDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSDate *serverDate = [serverDateFormatter dateFromString:serverDateInString];
        [WMBSession updateServerDateWithDate:serverDate];
        LogInfo(@"WMBSession updateServerDateWithStringDate: NSDate %@", serverDate);
    }
}

+ (void)updateServerDateWithDate:(NSDate *)serverDate
{
    if (serverDate)
    {
        LogInfo(@"WMBSession: updateServerDateWithDate:%@", serverDate);
        FXKeychain *keychain = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
        [keychain setObject:serverDate forKey:SERVER_DATE_KEY];
    }
}

+ (NSDate *)serverDate
{
    FXKeychain *keychain = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    NSDate *serverDate = [keychain objectForKey:SERVER_DATE_KEY];
    if (!serverDate)
    {
        serverDate = [NSDate date];
    }

//    NSDate *now = [NSDate date];
//    NSDate *sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
//    serverDate = sevenDaysAgo;
//    NSLog(@"7 days ago: %@", sevenDaysAgo);
    
//    NSDate *now = [NSDate date];
//    NSDate *daysAfter = [now dateByAddingTimeInterval:20*24*60*60];
//    serverDate = daysAfter;
//    NSLog(@"Twenty days after: %@", daysAfter);

    return serverDate;
}

@end
