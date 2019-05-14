//
//  WALFavoritesCache.h
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALCache.h"

@interface WALFavoritesCache : WALCache

/**
 *  Force an update in the list of favorites products. If it fails, it will keep the last valid favorites
 */
+ (void)update;

/**
 *  Cleans the list of favorites products
 */
+ (void)clean;

/**
 *  Stores a new array with of favorites in the cache.
 *  Prefer using + (void)update method
 *
 *  @param favorites NSArray with productSKUs
 */
+ (void)save:(nullable NSArray *)favorites;

/**
 *  Returns an array of products skus
 *
 *  @return NSArray of NSString. Each one is the productSKU of a product favorited
 */
+ (nonnull NSArray *)favorites;

/**
 *  Returns if a productSKU is a favorite product or not
 *
 *  @param productSKU NSNumber with the productSKU from a product
 *
 *  @return BOOL value indicating if this product is favorite or not
 */
+ (BOOL)isFavorite:(nonnull NSNumber *)productSKU;

/**
 *  Inserts a new productSKU in the favorites cache
 *
 *  @param productSKU NSNumber with the productSKU to be included in the favorites cache
 */
+ (void)insert:(nonnull NSNumber *)productSKU;

/**
 *  Removes a productSKU from the favorites cache
 *
 *  @param productSKU NSNumber with the productSKU to be removed from the favorites cache
 */

+ (void)remove:(nonnull NSNumber *)productSKU;

/**
 *  Removes a list of products SKUs from the favorites cache
 *
 *  @param productsSKUs NSArray with the products SKUs to be removed from the favorites cache
 */

+ (void)removeSKUs:(nonnull NSArray *)productsSKUs;

//Methods to help testing the class
/**
 *  Cleans the static variable that stores the home model
 */
+ (void)cleanInMemoryFavorites;


@end
