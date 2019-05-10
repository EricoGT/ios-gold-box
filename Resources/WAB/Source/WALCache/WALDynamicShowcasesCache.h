//
//  WALDynamicHomeCache.h
//  Walmart
//
//  Created by Renan on 6/27/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALCache.h"

@interface WALDynamicShowcasesCache : WALCache

/**
 *  Stores the dynamic showcases in cache
 *
 *  @param dynamicShowcases NSArray dynamic showcases to be cached
 */
+ (void)save:(nonnull NSArray *)dynamicShowcases;

/**
 *  Cleans the cached dynamic showcases
 */
+ (void)clean;

/**
 *  Returns a cached home model to populate home. May be nil if there is no home cached
 *
 *  @return NSArray dynamic showcases or nil if there's no dynamic showcases valid cache
 */
+ (nullable NSArray *)dynamicShowcasesFromCache;

/**
 *  Cleans the static variable that stores the home model
 */
+ (void)cleanInMemoryDynamicShowcases;

/**
 *  Update the static variable that controls the time when home should be refreshed.
 *  FOR UNIT TESTING PURPOSE ONLY
 *
 *  @param newRefreshTime Double with the new cache valid time
 */
+ (void)setCustomRefreshTime:(double)newRefreshTime;


@end
