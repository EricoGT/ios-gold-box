//
//  WMBTokenModel.m
//  Walmart
//
//  Created by Bruno Delgado on 7/22/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBTokenModel.h"
#import "WMBSession.h"

@interface WMBTokenModel ()
@end

@implementation WMBTokenModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"accessToken" : @"access_token",
                                                                  @"type": @"token_type",
                                                                  @"expiresIn": @"expires_in",
                                                                  @"refreshToken": @"refresh_token"}];
}

- (instancetype)initWithToken:(NSString *)token type:(NSString *)tokenType expiration:(NSNumber *)expires refreshToken:(NSString *)refresh
{
    if (self = [super init])
    {
        self.accessToken = token.length > 0 ? token : @"";
        self.type = tokenType.length > 0 ? tokenType : @"";
        self.expiresIn = expires ?: nil;
        self.refreshToken = refresh.length > 0 ? refresh : @"";
    }
    return self;
}

int countExpired = 0;

- (BOOL)isExpired
{
    BOOL expired = YES;
    
    countExpired++;
 
//    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:self.expiresIn.doubleValue];
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSince1970:self.expiresIn.doubleValue/1000.0f];
    
    LogInfo(@"Expires TIMESTAMP: %@", self.expiresIn);
    LogInfo(@"Expires in: %@", expirationDate);
    LogInfo(@"SERVER Date: %@", [WMBSession serverDate]);
    
    if (expirationDate)
    {
        if (expirationDate)
        {
            NSDate *serverDate = [WMBSession serverDate];
            
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"forceExpire"]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"forceExpire"];
                
                NSDate *now = [NSDate date];
                NSDate *daysAfter = [now dateByAddingTimeInterval:20*24*60*60];
                serverDate = daysAfter;
                NSLog(@"Twenty days after: %@", daysAfter);
            }
            
#endif
            
            if (serverDate)
            {
                NSTimeInterval distanceBetweenDates = [expirationDate timeIntervalSinceDate:serverDate];
                double secondsInMinute = 60;
                NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
                
                if (secondsBetweenDates > 0)
                {
                    expired = NO;
                    countExpired = 0;
                }
                
                if (countExpired == 2) {
                    expired = NO;
                    countExpired = 0;
                }
            }
        }
    }

    LogInfo(@"Count Expired: %i", countExpired);
    return expired;
}

@end
