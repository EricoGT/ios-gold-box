//
//  MDSTime.m
//  Walmart
//
//  Created by Marcelo Santos on 3/22/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "MDSTime.h"

@implementation MDSTime

+ (NSMutableDictionary *)watches {
    static NSMutableDictionary *Watches = nil;
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        Watches = @{}.mutableCopy;
    });
    return Watches;
}

+ (double)secondsFromMachTime:(uint64_t)time {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom / 1e9;
}

+ (void)start:(NSString *)name {
//    LogTime(@"\n\n------------------------------------\n[MDSTime] Starting measuring time for %@\n------------------------------------\n\n", name);
    uint64_t begin = mach_absolute_time();
    self.watches[name] = @(begin);
}

+ (void)stop:(NSString *)name {
    uint64_t end = mach_absolute_time();
    uint64_t begin = [self.watches[name] unsignedLongLongValue];
    LogTime(@"\n\n------------------------------------\n[MDSTime] Time taken for %@ %g s\n------------------------------------\n\n",
              name, [self secondsFromMachTime:(end - begin)]);
    [self.watches removeObjectForKey:name];
}

@end
