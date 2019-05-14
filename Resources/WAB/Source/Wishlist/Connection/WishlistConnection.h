//
//  WishlistConnection.h
//  Walmart
//
//  Created by Bruno on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"
#import "ProductDetailModel.h"
@class WishlistModel;

@interface WishlistConnection : WMBaseConnection

//
// Get products from the wishlist
//
- (void)wishlistProducts:(void (^)(WishlistModel *model))success failure:(void (^)(NSError *error))failure;

//
// Adds a product in the wishlist
//
- (void)addProductWithSKU:(NSString *)productSku productID:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error))completion;

//
// Removes a product from the wishlist
//
- (void)removeProductWithSKU:(NSString *)productSKU productId:(NSString *)productId completion:(void (^)(BOOL, NSError *))completion;

//
// Removes a list of products from the wishlist
//
- (void)removeProductsWithSKUs:(NSArray *)productsSKUs productsIds:(NSArray *)productsIds success:(void (^)(WishlistModel *model))success failure:(void (^)(NSError *error))failure;

//
// Sets if a product is bought or not
//
- (void)alreadyBoughtProductsWithSKUs:(NSArray *)productsSKUs success:(void (^)(WishlistModel *model))success failure:(void (^)(NSError *error))failure;

//
// Get favorited product skus
//
- (void)favoritedProducts:(void (^)(NSArray *favorites))success failure:(void (^)(NSError *error))failure;


@end
