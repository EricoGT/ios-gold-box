//
//  WBRWishlistConnection.h
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ## Mock Control

 * **CONFIGURATION_Release, CONFIGURATION_EnterpriseTK and DEBUG**:<br>
 _Build Production_<br>
 Should ALWAYS be configured with NO.<br>
 * **CONFIGURATION_DebugCalabash or CONFIGURATION_TestWm**:<br>
 _Build for test_<br>
 Choose YES or NO as required.<br>
 * **OTHER BUILDS**:<br>
 Choose YES or NO as required.
 */
// MOCK Control---------------------------------------
#if defined CONFIGURATION_Release || CONFIGURATION_EnterpriseTK || DEBUG
#define USE_MOCK_WISHLIST_GET NO
#define USE_MOCK_WISHLIST_SKU NO
#define USE_MOCK_WISHLIST_DEL NO
#define USE_MOCK_WISHLIST_ADD NO
#define USE_MOCK_WISHLIST_BOUGHT NO

#else
#if defined CONFIGURATION_DebugCalabash
#define USE_MOCK_WISHLIST_GET NO
#define USE_MOCK_WISHLIST_SKU NO
#define USE_MOCK_WISHLIST_DEL NO
#define USE_MOCK_WISHLIST_ADD NO
#define USE_MOCK_WISHLIST_BOUGHT NO

#else
#if defined CONFIGURATION_TestWm
#define USE_MOCK_WISHLIST_GET YES
#define USE_MOCK_WISHLIST_SKU YES
#define USE_MOCK_WISHLIST_DEL YES
#define USE_MOCK_WISHLIST_ADD YES
#define USE_MOCK_WISHLIST_BOUGHT YES

#else
#define USE_MOCK_WISHLIST_GET NO
#define USE_MOCK_WISHLIST_SKU NO
#define USE_MOCK_WISHLIST_DEL NO
#define USE_MOCK_WISHLIST_ADD NO
#define USE_MOCK_WISHLIST_BOUGHT NO

#endif
#endif
#endif
// ---------------------------------------------------

@interface WBRWishlistConnection : NSObject


/**
 Request to add product to wishlist

 @param productSku sku id
 @param productId product id
 @param sellerId seller id
 @param completion BOOL success, NSError and NSData
 */
- (void) requestAddWishlistProductWithSku:(NSString *)productSku productId:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error, NSData *data))completion;

/**
 Request to delete product from wishlist

 @param productsSKUs array of sku(s)
 @param success NSData:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
 <b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
 <b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */
- (void) requestDelWishProdSkusArray:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure;

/**
 Request to add product(s) to **bought** wishlist from user

 @param productsSKUs array of sku(s)
 @param success NSData:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
 <b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
 <b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */
- (void) requestBoughtWishProdSkusArray:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure;

/**
 Request to retrieve whole wishlist from user

 @param success NSDictionary:<br>
 <b>Products</b> with keys: productId, skuId, bought, sellerId, date, statusPrice, quantity and object sellerOptions.<br>
 <b>sellerOptions</b> with keys: sku, name, hasExtendedWarranty, currency, originalPrice, discountPrice, price, quantityAvailable, active, available, instalment, instalmentValue, sellerId, seller, imageIds and object: rating.<br>
 <b>rating</b> with keys: value and total.
 @param failure NSError and NSData
 */
- (void) requestWishlist:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure;


/**
 Request to retrieve just a list of sku(s) from user

 @param success NSDictionary:<br>
 <b>skusIds</b>: Skus array from user
 @param failure NSError and NSData
 */
- (void) requestWishlistSku:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure;

@end
