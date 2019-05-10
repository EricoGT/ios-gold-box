//
//  WBRProduct.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRModelSendReview.h"

typedef void(^kSuccessBlock)(NSDictionary *dataJson);
typedef void(^kFailureBlock)(NSDictionary *dictError);

@interface WBRProduct : NSObject

/**
 Perform a search

 @param query Query to search. Ex.: ft=automacao
 @param sortParam _NOT USED_
 @param success NSData:<br>
 <b>count</b><br>
 <b>products</b> with keys: productId, skuId, title, imageId, hasMoreOffers, hasSkuOptions, hasAvailability, sellerId, totalColors and **price** [listPrice, sellPrice], instalment, instalmentValue and stampImage.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
- (void) getSearchWithQuery:(NSString *)query sortParameter:(NSString *)sortParam successBlock:(void (^)(NSData *dataJson))success failureBlock:(void (^)(NSDictionary *dictError))failure;

/**
 Product Detail

 @param urlProduct url product detail with parameters or not
 @param showcaseId showcase id
 @param success NSData:<br>
 <b>count</b><br>
 <b>product</b> with keys: imagesIds, productId, skuId, title, departmentId, categoryId, subCategoryId, stampUrl, stampTitle, stampDescription, stampFullDescription, deliveryStampUrl, optionsType, variations and **offers**[sku, hasExtendedWarranty, **seller**[id, name] , **price**[listPrice, sellPrice, installmentAmount, valuePerInstallment], available].
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
- (void) getProductDetail:(NSString *)urlProduct showcaseId:(NSString *)showcaseId successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

/**
 Product Warranty

 @param sku sku product
 @param sellerId seller id
 @param sellPrice sellprice value
 @param success NSData:<br>
 <b>warranties</b> with keys: id, type, period, name, **price**[sellPrice, installmentAmount, valuePerInstallment].
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
- (void) getWarrantyProductDetail:(NSString *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;

/**
 Product Reviews
 
 @param urlProduct url product reviews with parameters or not
 @param showcaseId showcase id
 @param success NSData:<br>
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.

 */
- (void) getProductReviews:(NSString *)urlProduct successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure;


/**
 Post Product Review
 
 @param review review object to send to server
 @param success NSData:<br>
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 
 */
- (void)postProductReview:(WBRModelSendReview *)review withProductId:(NSString *)productId successBlock:(kSuccessBlock) success failure:(kFailureBlock)failure;

/**
 Post a review evaluation

 @param evaluation evaluation of review (negative and positive)
 @param productId the product of the given review
 @param reviewId
 @param success NSData:<br>
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
- (void)postReviewEvaluation:(BOOL)evaluation ofProduct:(NSNumber *)productId forReview:(NSNumber *)reviewId successBlock:(kSuccessBlock)success failure:(kFailureBlock)failure;

@end



