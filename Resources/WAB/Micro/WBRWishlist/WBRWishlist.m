//
//  WBRWishlist.m
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRWishlist.h"
#import "WBRWishlistConnection.h"

@implementation WBRWishlist

- (void) getWishlist:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure {
    
    [[WBRWishlistConnection new] requestWishlist:^(NSDictionary *dictWishlist) {
        
        if (success) success(dictWishlist);
        
    } failure:^(NSError *error, NSData *data) {
        
        if (failure) failure(error, data);
    }];
}

- (void) getWishlistSku:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure {
    
    [[WBRWishlistConnection new] requestWishlistSku:^(NSDictionary *dictWishlist) {
        
        if (success) success(dictWishlist);
        
    } failure:^(NSError *error, NSData *data) {
        
        if (failure) failure(error, data);
    }];
}

- (void) addWishlistProductWithSku:(NSString *)productSku productId:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error, NSData *data))completion {
    
    [[WBRWishlistConnection new] requestAddWishlistProductWithSku:productSku productId:productId sellerId:sellerId completion:^(BOOL success, NSError *error, NSData *data) {
        
        completion (success, error, data);
    }];
}

- (void) delWishlistProductWithSku:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure {
    
    [[WBRWishlistConnection new] requestDelWishProdSkusArray:productsSKUs success:^(NSData *data) {
        
        success (data);
        
    } failure:^(NSError *error, NSData *dataError) {
        
        failure (error, dataError);
    }];
}

- (void) boughtWishlistProductWithSku:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure {
    
    [[WBRWishlistConnection new] requestBoughtWishProdSkusArray:productsSKUs success:^(NSData *data) {
        
        success (data);
        
    } failure:^(NSError *error, NSData *dataError) {
        
        failure (error, dataError);
    }];
}

@end
