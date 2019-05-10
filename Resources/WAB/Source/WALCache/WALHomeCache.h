//
//  WALHomeCache.h
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALCache.h"
@class HomeModel;

@interface WALHomeCache : WALCache

/**
 *  Stores in the cache the home model
 *
 *  @param home HomeModel object to be cached
 */
+ (void)save:(nonnull HomeModel *)home;

/**
 *  Cleans the cached home
 */
+ (void)clean;

/**
 *  Returns a cached home model to populate home. May be nil if there is no home cached
 *
 *  @return HomeModel object or nil nil if there is no home cached
 */
+ (nullable HomeModel *)homeFromCache;

//Methods to help testing the class
/**
 *  Cleans the static variable that stores the home model
 */
+ (void)cleanInMemoryHome;

/**
 *  Update the static variable that controls the time when home should be refreshed.
 *  FOR UNIT TESTING PURPOSE ONLY
 *
 *  @param newRefreshTime Double with the new cache valid time
 */
+ (void)setCustomRefreshTime:(double)newRefreshTime;

@end
