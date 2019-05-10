//
//  TimeManager.m
//  Walmart
//
//  Created by Marcelo Santos on 1/12/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "TimeManager.h"

#import "WBRUTM.h"

@implementation TimeManager


+ (void) assignTimeSetup {
    
    [self assignTime:@"expirationSetup" andTimeInSeconds:EXPIRE_SECONDS_SETUP];
}

+ (void) assignTimeHomeDynamic {
    
    [self assignTime:@"expirationDynamic" andTimeInSeconds:EXPIRE_SECONDS_HOME_DYNAMIC];
}

+ (void) assignTimeHomeStatic {
    
    [self assignTime:@"expirationStatic" andTimeInSeconds:EXPIRE_SECONDS_HOME_STATIC];
}


+ (void) assignTime:(NSString *) keyObject andTimeInSeconds:(int) seconds {
    
    NSDate *nowDate = [NSDate date];
    LogMicro(@"[TIME] Device Date: %@", nowDate);
    //Save expiration date
    NSDate *expireDate = [nowDate dateByAddingTimeInterval:seconds];
    LogMicro(@"[TIME] Expiration Date: %@", expireDate);
    [[NSUserDefaults standardUserDefaults] setObject:expireDate forKey:keyObject];
}


+ (BOOL) shouldMakeRequestSetup {
    
    NSDate *expiration = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationSetup"];
    
    return [self isValidTimeBetweenRequests:expiration];
}

+ (BOOL) shouldMakeRequestHomeDynamic {
    
    NSDate *expiration = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDynamic"];
    
    return [self isValidTimeBetweenRequests:expiration];
}

+ (BOOL) shouldMakeRequestHomeStatic {
    
    NSDate *expiration = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationStatic"];
    
    return [self isValidTimeBetweenRequests:expiration];
}


+ (BOOL) isValidTimeBetweenRequests:(NSDate *) expiration {
    
    if (!expiration) {
        return NO;
    }
    
    //Verify if valid
    BOOL isValidTimeBetweenRequests = YES;
    
    NSDate *now = [NSDate date];
    
//    LogMicro(@"Expiration: %@", expiration);
//    LogMicro(@"Now       : %@", now);
    
    NSTimeInterval distanceBetweenDates = [expiration timeIntervalSinceDate:now];
    
    if (distanceBetweenDates < 0) {
        isValidTimeBetweenRequests = NO;
    }

    return isValidTimeBetweenRequests;
}



// Util, but we don't use it

+ (NSString *) checkDateDeviceForTime:(int) timeInSeconds withDateFromServer:(NSString *) serverDateInString {
    
    NSDateFormatter *serverDateWmFormatter = [NSDateFormatter new];
    serverDateWmFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    serverDateWmFormatter.dateFormat = @"E, d MMM yyyy HH:mm:ss Z";
    serverDateWmFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDate *serverWmDate = [serverDateWmFormatter dateFromString:serverDateInString];
    LogMicro(@"[TIME] Server WM Date: %@", serverWmDate);
    
    NSDate *now = [NSDate date];
    LogMicro(@"[TIME] Device Date: %@", now);
    
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:serverWmDate];
    LogMicro(@"[TIME] Difference Date: %f", distanceBetweenDates);
    
    if (distanceBetweenDates > timeInSeconds) {
        
        return [serverDateWmFormatter stringFromDate:now];
    } else {
        return [serverDateWmFormatter stringFromDate:serverWmDate];
    }
}

+ (void)updateServerDateWithResponse:(NSHTTPURLResponse *)response {
    
    LogInfo(@"TimeManager: updateServerDateWithResponse:");
    
    if ([response.allHeaderFields objectForKey:@"Date"]) {
        
        NSString *dateString = response.allHeaderFields[@"Date"];
        
        LogInfo(@"TimeManager: updateServerDateWithResponse: withDateString:%@", dateString);
        
        if (![dateString isEqualToString:@""] &&
            dateString != nil) {
            
            NSDate *serverDate = [self serverResponseDateStringToDate:dateString];
            LogInfo(@"TimeManager: updateServerDateWithResponse: withNSDate:%@", serverDate);
            
            if (serverDate) {
                [WMBSession updateServerDateWithDate:serverDate];
                [WBRUTM updateHourIfNeeded:serverDate];
            }
        }
    }
    else {
        LogInfo(@"TimeManager: saving server error: There's no 'Date' header");
    }
}

+ (NSDate *)serverResponseDateStringToDate:(NSString *)dateString {
    
    LogInfo(@"TimeManager: serverResponseDateStringToDate: dateString: %@", dateString);
    NSDateFormatter *serverDateFormatter = [NSDateFormatter new];
    serverDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    serverDateFormatter.dateFormat = @"E, d MMM yyyy HH:mm:ss Z";
    NSDate *serverDate = [serverDateFormatter dateFromString:dateString];
    LogInfo(@"TimeManager: serverResponseDateStringToDate: NSDate: %@", serverDate);
    
    return serverDate;
}

+ (NSDate *)invalidateUTMDate:(NSDate *)UTMDate {
    
    NSTimeInterval timeToInvalidateUTM = -EXPIRE_SECONDS_UTMS;
    NSDate *expiredDate = [UTMDate dateByAddingTimeInterval:timeToInvalidateUTM];
    
    return expiredDate;
}

+ (BOOL)UTMDateStillValid:(NSDate *)UTMDate {
    
    NSDate *currentServerDate = [WMBSession serverDate];
    NSTimeInterval distanceBetweenUTMAndCurrentDate = [currentServerDate timeIntervalSinceDate:UTMDate];
    BOOL UTMStillValid = distanceBetweenUTMAndCurrentDate < EXPIRE_SECONDS_UTMS ? YES : NO;
    
    return UTMStillValid;
}

@end
