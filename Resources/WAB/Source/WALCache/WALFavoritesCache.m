//
//  WALFavoritesCache.m
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALFavoritesCache.h"
#import "WishlistConnection.h"

static NSString * const FavoritesCacheIdentifier = @"FavoritesCache";
static NSArray *inMemoryFavorites;

@implementation WALFavoritesCache

#pragma mark - Static variable helper
+ (void)cleanInMemoryFavorites
{
    inMemoryFavorites = nil;
}

#pragma mark - Update
+ (void)update
{
    NSOperationQueue *queue = [NSOperationQueue new];
    WALFavoritesCache *cacheInstance = [WALFavoritesCache new];
    NSInvocationOperation *updateOperation = [[NSInvocationOperation alloc] initWithTarget:cacheInstance selector:@selector(updateFavorites) object:nil];
    [queue addOperation:updateOperation];
}

- (void)updateFavorites
{
    if ([WALSession isAuthenticated])
    {
        
        [[WishlistConnection new] favoritedProducts:^(NSArray *favorites) {
            
            [WALFavoritesCache save:favorites];
            
        } failure:^(NSError *error) {
            
            LogInfo(@"[WALCache] Error getting products from favorites: %@", error);
        }];
        
//        [self guIDWithCompletionBlock:^(NSString *guid)
//         {
//             if (guid.length > 0)
//             {
//                 WishlistConnection *connection = [WishlistConnection new];
//                 [connection favoritedProducts:^(NSArray *favorites)
//                  {
//                      [WALFavoritesCache save:favorites];
//                  }
//                                       failure:^(NSError *error)
//                  {
//                      LogInfo(@"[WALCache] Error getting products from favorites: %@", error);
//                  }];
//             }
//             else
//             {
//                 LogInfo(@"[WALCache] Error getting guid to load favorites");
//             }
//         }];
    }
}

#pragma mark - Save
+ (void)save:(NSArray *)favorites
{
    if (!favorites) return;

    WALFavoritesCache *cacheInstance = [WALFavoritesCache new];
    NSData *favoritesData = [NSKeyedArchiver archivedDataWithRootObject:favorites];
    [cacheInstance storeCache:favoritesData withIdentifier:FavoritesCacheIdentifier];
    inMemoryFavorites = favorites;
    LogInfo(@"[WALCache] wishlist cache saved. Wishlist: %@", inMemoryFavorites);
}

#pragma mark - Clean
+ (void)clean
{
    WALFavoritesCache *cacheInstance = [WALFavoritesCache new];
    [cacheInstance removeCacheWithIdentifier:FavoritesCacheIdentifier];
    [cacheInstance.keychainAccess removeObjectForKey:kGUIDkey];
    inMemoryFavorites = nil;
    LogInfo(@"[WALCache] wishlist cache cleaned.");
}

#pragma mark - Retrieve
+ (nonnull NSArray *)favorites
{
    if (inMemoryFavorites) return inMemoryFavorites;

    NSArray *favorites = @[];
    WALFavoritesCache *cacheInstance = [WALFavoritesCache new];
    NSData *favoritesData = [cacheInstance cacheWithIdentifier:FavoritesCacheIdentifier];
    if (favoritesData)
    {
        favorites = [NSKeyedUnarchiver unarchiveObjectWithData:favoritesData];
        inMemoryFavorites = favorites;
        LogInfo(@"[WALCache] Wishlist loaded from cache: %@", inMemoryFavorites);
    }
    else
    {
        LogInfo(@"[WALCache] We don't have favorites cached. Retrieving favorites and caching...");
        [WALFavoritesCache update];
    }

    return favorites;
}

+ (BOOL)isFavorite:(nonnull NSNumber *)productSKU
{
    if (!productSKU) return NO;

    NSArray *favorites = [self favorites];
    return [favorites containsObject:productSKU];
}

#pragma mark - Mutate
+ (void)insert:(nonnull NSNumber *)productSKU
{
    if (!productSKU) return;

    NSMutableArray *favorites = inMemoryFavorites.mutableCopy;
    [favorites addObject:productSKU];
    [self save:favorites.copy];
    
    LogInfo(@"[WALCache] SKU %@ added to cache.", productSKU);
    LogInfo(@"[WALCache] List Skus after add: %@", favorites);
}

+ (void)remove:(nonnull NSNumber *)productSKU
{
    [WALFavoritesCache removeSKUs:@[productSKU]];
}

+ (void)removeSKUs:(NSArray *)productsSKUs {
    NSMutableArray *favorites = inMemoryFavorites.mutableCopy;
    [favorites removeObjectsInArray:productsSKUs];
    [self save:favorites.copy];
    
    LogInfo(@"[WALCache] SKUs %@ removed from cache.", productsSKUs);
}


@end
