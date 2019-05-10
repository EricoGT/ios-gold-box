//
//  WBRWishlist.h
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRWishlist : NSObject


/**
 Return Wishlist list

 @param success NSDictionary:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
<b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
<b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */

- (void) getWishlist:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure;

/**
 Return Wishlist skus list from current user
 
 @param success NSDictionary:<br>
 <b>skusIds</b>: Skus array from user
 @param failure NSError and NSData
 */

- (void) getWishlistSku:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure;

/**
 Add Sku product to user's wishlist

 @param productSku product sku to add
 @param productId product id to add
 @param sellerId seller id to add
 @param completion BOOL success, NSError and NSData with keys: productId, skuId, bought, sellerId
 */
- (void) addWishlistProductWithSku:(NSString *)productSku productId:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error, NSData *data))completion;

/**
 Delete Sku or array of Skus product(s) from user's wishlist

 @param productsSKUs array of sku(s)
 @param success NSData:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
 <b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
 <b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */
- (void) delWishlistProductWithSku:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure;


/**
 Add product(s) to user's **bought** wishlist

 @param productsSKUs array of sku(s) id(s)
 @param success NSData:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
 <b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
 <b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */
- (void) boughtWishlistProductWithSku:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure;

@end
