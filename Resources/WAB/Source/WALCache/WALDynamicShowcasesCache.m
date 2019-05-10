//
//  WALDynamicHomeCache.m
//  Walmart
//
//  Created by Renan on 6/27/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALDynamicShowcasesCache.h"

#import "ShowcaseModel.h"
#import "WishlistInteractor.h"
#import "TimeManager.h"

static NSString * const DynamicShowcasesCacheIdentifier = @"DynamicShowcasesCache";
static NSString * const DynamicShowcasesTimestampCacheIdentifier = @"DynamicShowcasesTimestampCacheIdentifier";
//static double DynamicShowRefreshTimeInSeconds = 180;
static double DynamicShowRefreshTimeInSeconds = EXPIRE_SECONDS_HOME_DYNAMIC;

static NSArray *inMemoryHome;
static NSDate *inMemoryTimestamp;

@implementation WALDynamicShowcasesCache

#pragma mark - Static variable helper
+ (void)cleanInMemoryDynamicShowcases
{
    inMemoryHome = nil;
    inMemoryTimestamp = nil;
}

+ (void)setCustomRefreshTime:(double)newRefreshTime
{
    DynamicShowRefreshTimeInSeconds = newRefreshTime;
}

#pragma mark - Save
+ (void)save:(NSArray *)dynamicShowcases
{
    NSDate *timestamp = [NSDate date];
    WALDynamicShowcasesCache *cacheInstance = [WALDynamicShowcasesCache new];
    NSArray *dynamicShowcasesDictionaries = [ShowcaseModel arrayOfDictionariesFromModels:dynamicShowcases];
    NSData *dynamicShowcasesData = [NSKeyedArchiver archivedDataWithRootObject:dynamicShowcasesDictionaries];
    NSData *timestampData = [NSKeyedArchiver archivedDataWithRootObject:timestamp];
    [cacheInstance storeCache:dynamicShowcasesData withIdentifier:DynamicShowcasesCacheIdentifier];
    [cacheInstance storeCache:timestampData withIdentifier:DynamicShowcasesTimestampCacheIdentifier];

    inMemoryHome = dynamicShowcases;
    inMemoryTimestamp = timestamp;
}

#pragma mark - Clean
+ (void)clean
{
    WALDynamicShowcasesCache *cacheInstance = [WALDynamicShowcasesCache new];
    [cacheInstance removeCacheWithIdentifier:DynamicShowcasesCacheIdentifier];
    [cacheInstance removeCacheWithIdentifier:DynamicShowcasesTimestampCacheIdentifier];

    inMemoryHome = nil;
    inMemoryTimestamp = nil;
}

#pragma mark - Retrieve
+ (NSArray *)dynamicShowcasesFromCache
{
    NSDate *timestamp = inMemoryTimestamp;
    NSArray *dynamicShowcases = inMemoryHome;
    WALDynamicShowcasesCache *cacheInstance = [WALDynamicShowcasesCache new];

    if (!timestamp)
    {
        NSData *timestampData = [cacheInstance cacheWithIdentifier:DynamicShowcasesTimestampCacheIdentifier];
        if (!timestampData) return nil;

        timestamp = (NSDate *)[NSKeyedUnarchiver unarchiveObjectWithData:timestampData];
        inMemoryTimestamp = timestamp;
    }

    if (!dynamicShowcases)
    {
        NSData *dynamicShowcasesData = [cacheInstance cacheWithIdentifier:DynamicShowcasesCacheIdentifier];
        if (!dynamicShowcasesData) return nil;

        NSArray *dynamicShowcasesDictionaries = (NSArray *) [NSKeyedUnarchiver unarchiveObjectWithData:dynamicShowcasesData];
        NSError *parserError;
        dynamicShowcases = [ShowcaseModel arrayOfModelsFromDictionaries:dynamicShowcasesDictionaries error:&parserError];
        if (!parserError)
        {
            for (ShowcaseModel *dynamicShowcase in dynamicShowcases)
            {
                dynamicShowcase.dynamic = YES;
            }
            [WishlistInteractor assignWishlistStatusToShowcases:dynamicShowcases];

            inMemoryHome = dynamicShowcases;
            dynamicShowcases = inMemoryHome;
        }
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:timestamp];
    return (timeInterval <= DynamicShowRefreshTimeInSeconds) ? dynamicShowcases : nil;
}

@end
