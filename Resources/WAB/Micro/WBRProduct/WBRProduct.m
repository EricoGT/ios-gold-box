//
//  WBRProduct.m
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProduct.h"
#import "WBRProductConnection.h"

@implementation WBRProduct

- (void) getSearchWithQuery:(NSString *)query sortParameter:(NSString *)sortParam successBlock:(void (^)(NSData *dataJson))success failureBlock:(void (^)(NSDictionary *dictError))failure {
    
    [[WBRProductConnection new] requestSearchQuery:query sortParameter:sortParam successBlock:^(NSData *jsonData) {
        
         if (success) success(jsonData);
        
    } failure:^(NSDictionary *dictError) {
        
        if (failure) failure (dictError);
    }];
}

- (void) getProductDetail:(NSString *)urlProduct showcaseId:(NSString *)showcaseId successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    [[WBRProductConnection new] requestProductDetail:urlProduct showcaseId:showcaseId successBlock:^(NSData *jsonData) {
        
        if (success) success(jsonData);
        
    } failure:^(NSDictionary *dictError) {
        
        if (failure) failure (dictError);
    }];
}

- (void) getWarrantyProductDetail:(NSString *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    [[WBRProductConnection new] requestWarrantyProductDetail:sku sellerId:sellerId sellPrice:sellPrice successBlock:^(NSData *jsonData) {
         if (success) success(jsonData);
    } failure:^(NSDictionary *dictError) {
        if (failure) failure (dictError);
    }];
}

- (void) getProductReviews:(NSString *)urlProduct successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    [[WBRProductConnection new] requestProductReviews:urlProduct successBlock:^(NSData *jsonData) {
        
        if (success) success(jsonData);
        
    } failure:^(NSDictionary *dictError) {
        
        if (failure) failure (dictError);
    }];
}

- (void)postProductReview:(WBRModelSendReview *)review
            withProductId:(NSString *)productId
             successBlock:(kSuccessBlock)success
                  failure:(kFailureBlock)failure {
    
    [[WBRProductConnection new] sendProductReview:review withProductId:productId successBlock:success failure:failure];
}

- (void)postReviewEvaluation:(BOOL)evaluation ofProduct:(NSNumber *)productId forReview:(NSNumber *)reviewId successBlock:(kSuccessBlock)success failure:(kFailureBlock)failure {

    NSString *urlString = [OFUrls getURLPostProductReviewEvaluation:productId reviewId:reviewId];
    [[WBRProductConnection new] postProductReviewEvaluation:urlString evaluation:[NSNumber numberWithBool:evaluation] successBlock:success failure:failure];
}


@end
