//
//  WishlistInteractor.m
//  Walmart
//
//  Created by Renan Cargnin on 3/15/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WishlistInteractor.h"

#import "WALFavoritesCache.h"
#import "ShowcaseModel.h"

@implementation WishlistInteractor

+ (NSArray *)correspondenceArrayWithWishlistSKUs:(NSArray *)wishlistSKUs sortedProductsSKUs:(NSArray *)sortedProductsSKUs {
    NSMutableArray *correspondenceArray = [NSMutableArray new];
    
    if (wishlistSKUs.count > 0 && sortedProductsSKUs.count > 0) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"integerValue" ascending:YES];
        NSArray *sortedWishlistSKUs = [wishlistSKUs sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        NSInteger wishlistIndex = 0;
        NSInteger currentWishlistSKU = [sortedWishlistSKUs.firstObject integerValue];
        NSInteger wishlistCount = sortedWishlistSKUs.count;
        
        for (NSNumber *productSKU in sortedProductsSKUs) {
            NSInteger productSKUInteger = productSKU.integerValue;
            while (productSKUInteger > currentWishlistSKU && wishlistIndex < wishlistCount - 1) {
                currentWishlistSKU = [sortedWishlistSKUs[++wishlistIndex] integerValue];
            }
            [correspondenceArray addObject:@(productSKUInteger == currentWishlistSKU)];
        }
    }
    
    return correspondenceArray.copy;
}

+ (void)assignWishlistStatusToProducts:(NSArray *)products skuKey:(NSString *)skuKey wishlistKey:(NSString *)wishlistKey {
    NSArray *wishlist = [WALFavoritesCache favorites];
    
    NSSortDescriptor *productsSort = [NSSortDescriptor sortDescriptorWithKey:skuKey ascending:YES];
    NSArray *sortedProducts = [products sortedArrayUsingDescriptors:@[productsSort]];
    NSArray *wishlistCorrespondanceArray = [WishlistInteractor correspondenceArrayWithWishlistSKUs:wishlist sortedProductsSKUs:[sortedProducts valueForKey:skuKey]];
    
    if (wishlistCorrespondanceArray.count == sortedProducts.count) {
        for (NSInteger i = 0; i < sortedProducts.count; i++) {
            NSObject *product = sortedProducts[i];
            NSNumber *isFavorite = wishlistCorrespondanceArray[i];
            if ([product respondsToSelector:NSSelectorFromString(wishlistKey)]) {
                [product setValue:isFavorite forKey:wishlistKey];
            }
        }
    }
}

+ (void)assignWishlistStatusToShowcases:(NSArray *)showcases {
    NSMutableArray *allProductsMutable = [NSMutableArray new];
    for (ShowcaseModel *showcase in showcases) {
        [allProductsMutable addObjectsFromArray:showcase.products];
    }
    [WishlistInteractor assignWishlistStatusToProducts:allProductsMutable.copy skuKey:@"skuId" wishlistKey:@"wishlist"];
}

@end
