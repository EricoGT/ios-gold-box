//
//  WishlistInteractor.h
//  Walmart
//
//  Created by Renan Cargnin on 3/15/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WishlistInteractor : NSObject

/**
 *  Creates and returns an array with NSNumbers with the corresponding bool values of the SKUs wishlist status.
 *
 *  @param wishlistSKUs       List of favorited SKUs
 *  @param sortedProductsSKUs Sorted list of products SKUs
 *
 *  @return NSArray with the corresponding bool values of the SKUs wishlist status
 */
+ (NSArray *)correspondenceArrayWithWishlistSKUs:(NSArray *)wishlistSKUs sortedProductsSKUs:(NSArray *)sortedProductsSKUs;

/**
 *  Assigns wishlist status for products independently of the product model class.
 *
 *  @param products    List of product models
 *  @param skuKey      Name of the product model sku property
 *  @param wishlistKey Name of the product wishlist status property
 */
+ (void)assignWishlistStatusToProducts:(NSArray *)products skuKey:(NSString *)skuKey wishlistKey:(NSString *)wishlistKey;

/**
 *  Assigns wishlist status for products inside a list of showcases.
 *
 *  @param showcases List of showcases
 */
+ (void)assignWishlistStatusToShowcases:(NSArray *)showcases;

@end
