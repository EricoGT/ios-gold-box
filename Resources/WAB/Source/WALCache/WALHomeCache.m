//
//  WALHomeCache.m
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALHomeCache.h"
#import "HomeModel.h"
#import "TimeManager.h"

static NSString * const HomeCacheIdentifier = @"HomeCache";
static NSString * const HomeTimestampCacheIdentifier = @"HomeTimestampCacheIdentifier";
//static double HomeRefreshTimeInSeconds = 300;
static double HomeRefreshTimeInSeconds = EXPIRE_SECONDS_HOME_STATIC;

static HomeModel *inMemoryHome;
static NSDate *inMemoryTimestamp;

@implementation WALHomeCache

#pragma mark - Static variable helper
+ (void)cleanInMemoryHome
{
    inMemoryHome = nil;
    inMemoryTimestamp = nil;
}

+ (void)setCustomRefreshTime:(double)newRefreshTime
{
    HomeRefreshTimeInSeconds = newRefreshTime;
}

#pragma mark - Save
+ (void)save:(nonnull HomeModel *)home
{
    NSDate *timestamp = [NSDate date];
    WALHomeCache *cacheInstance = [WALHomeCache new];
    NSDictionary *homeDictionary = home.toDictionary;
    NSData *homeData = [NSKeyedArchiver archivedDataWithRootObject:homeDictionary];
    NSData *timestampData = [NSKeyedArchiver archivedDataWithRootObject:timestamp];
    [cacheInstance storeCache:homeData withIdentifier:HomeCacheIdentifier];
    [cacheInstance storeCache:timestampData withIdentifier:HomeTimestampCacheIdentifier];

    inMemoryHome = home;
    inMemoryTimestamp = timestamp;
}

#pragma mark - Clean
+ (void)clean
{
    WALHomeCache *cacheInstance = [WALHomeCache new];
    [cacheInstance removeCacheWithIdentifier:HomeCacheIdentifier];
    [cacheInstance removeCacheWithIdentifier:HomeTimestampCacheIdentifier];

    inMemoryHome = nil;
    inMemoryTimestamp = nil;
}

#pragma mark - Retrieve
+ (nullable HomeModel *)homeFromCache
{
    NSDate *timestamp = inMemoryTimestamp;
    HomeModel *model = inMemoryHome;

    WALHomeCache *cacheInstance = [WALHomeCache new];
    if (!timestamp)
    {
        NSData *timestampData = [cacheInstance cacheWithIdentifier:HomeTimestampCacheIdentifier];
        if (!timestampData) return nil;

        timestamp = (NSDate *)[NSKeyedUnarchiver unarchiveObjectWithData:timestampData];
        inMemoryTimestamp = timestamp;
    }

    if (!model)
    {
        NSData *homeData = [cacheInstance cacheWithIdentifier:HomeCacheIdentifier];
        if (!homeData) return nil;

        NSDictionary *homeDictionary = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:homeData];
        NSError *parserError;
        model = [[HomeModel alloc] initWithDictionary:homeDictionary error:&parserError];
        if (!parserError)
        {
            inMemoryHome = model;
            model = inMemoryHome;
        }
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:timestamp];
    return (timeInterval <= HomeRefreshTimeInSeconds) ? model : nil;
}

@end
