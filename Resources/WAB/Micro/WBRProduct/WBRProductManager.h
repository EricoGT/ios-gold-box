//
//  WBRProductManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 19/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRProductManager : NSObject

typedef void(^kProductManagerSuccessBlock)(void);
typedef void(^kProductManagerFailureBlock)(NSError *error);

typedef void(^kProductManagerNotifyMeSuccessBlock)(BOOL success);

typedef void(^kProductManagerGetExtendedWarrantySuccessBlock)(NSString *html);
typedef void(^kProductManagerGetExtendedWarrantyFailureBlock)(NSString *message);

/**
 Get the products description from API
 
 @param productId product id
 @param successBlock success response
 @param failureBlock failure response
 */
+ (void)getProductDescriptionWithProductId:(NSString *)productId successBlock:(void (^)(NSString *))successBlock failureBlock:(kProductManagerFailureBlock)failureBlock;


/**
 Get the prodcut specification from API

 @param productId product identifier
 @param successBlock success response
 @param failureBlock failure response
 */
+ (void)getProductSpecificationWithProductId:(NSString *)productId successBlock:(void (^)(NSString *))successBlock failureBlock:(kProductManagerFailureBlock)failureBlock;

+ (void)notifyUser:(NSString *)userName withEmail:(NSString *)email forProductSku:(NSString *)productSKU successBlock:(kProductManagerNotifyMeSuccessBlock)successBlock;

+ (void)getExtendedWarrantyLicenseWithSuccessBlock:(kProductManagerGetExtendedWarrantySuccessBlock)successBlock failureBlock:(kProductManagerGetExtendedWarrantyFailureBlock)failureBlock;
+ (void)getExtendedWarrantyDescriptionWithSuccessBlock:(kProductManagerGetExtendedWarrantySuccessBlock)successBlock failureBlock:(kProductManagerGetExtendedWarrantyFailureBlock)failureBlock;

@end
