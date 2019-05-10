//
//  WBRCheckoutManager.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kCheckoutManagerSuccessBlock)(NSArray *dataArray);
typedef void(^kCheckoutManagerFailureBlock)(NSError *error);

typedef void(^kCheckoutManagerSuccessStringBlock)(NSString *dataString);
typedef void(^kCheckoutManagerFailureStringBlock)(NSError *error, NSString *dataString);

@interface WBRCheckoutManager : NSObject


/**
 Get the user active Cart

 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getCartWithSuccess:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock;


/**
 Update the product on cart with dictionary header and json product body

 @param productDict info about cart
 @param jsonBody info about product
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)updateProductWithCartDict:(NSDictionary *)cartDict andProductBodyJson:(NSString *)productJsonBody success:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock;

/**
 Add a product on cart with SKU

 @param sku product sku
 @param sellerId seller id
 @param warrantiesId warranties id
 @param quantity quantity of products
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)addProductToCartWithSKU:(NSNumber *)sku sellerId:(NSString *)sellerId warrantiesId:(NSArray *)warrantiesId quantity:(NSUInteger)quantity success:(kCheckoutManagerSuccessBlock)successBlock failure:(kCheckoutManagerFailureBlock)failureBlock;


/**
 Remove product from cart

 @param cartDict cart header dict
 @param productJsonBody product json body
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)removeProductWithCartDict:(NSDictionary *)cartDict andProductBodyJson:(NSString *)productJsonBody success:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock;


/**
 Get the user Address list

 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getAddressList:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock;


/**
 Load delivery options

 @param successBlock success Block
 @param failureBlock failure Block
 */
+ (void)getDeliveryOptions:(NSString *)deliveryId successBlock:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock;

@end
