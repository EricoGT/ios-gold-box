//
//  WishlistConnection.m
//  Walmart
//
//  Created by Bruno on 11/23/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WishlistConnection.h"
#import "WishlistModel.h"
#import "WALFavoritesCache.h"
#import "WBRWishlist.h"

typedef enum : NSUInteger {
    RequestTypeAdd,
    RequestTypeRemove,
    RequestTypeSetBoughtState,
    RequestTypeProducts
} RequestType;

@interface WishlistConnection ()

@property (nonatomic, strong) NSString *endpoint;

@end

@implementation WishlistConnection

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.endpoint = [[OFUrls new] getURLWishlistListEndpoint];
    }
    return self;
}

- (void)wishlistProducts:(void (^)(WishlistModel *model))success failure:(void (^)(NSError *error))failure
{
    
    [[WBRWishlist new] getWishlist:^(NSDictionary *dictWishlist) {
        
        NSError *parserError;
        WishlistModel *products = [[WishlistModel alloc] initWithDictionary:dictWishlist error:&parserError];
        
        if (!parserError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success (products);
            });
        }
        else {
            NSError *customError = [self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(customError);
            });
        }
        
    } failure:^(NSError *error, NSData *data) {
        
        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeProducts];
        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(customError);
        });
    }];
    
    
//    NSURL *url = [NSURL URLWithString:_endpoint];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
//    [request setHTTPMethod:@"GET"];
//    
//    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        NSError *parserError;
//        WishlistModel *products = [[WishlistModel alloc] initWithModelToJSONDictionary:json error:&parserError];
//
//        if (parserError) {
//            LogError *log = [LogError new];
//            log.absolutRequest = url.absoluteString;
//            log.code = [NSString stringWithFormat:@"%ld", (long)parserError.code];
//            log.data = parserError.localizedDescription ? [parserError.localizedDescription dataUsingEncoding:NSUTF8StringEncoding] : nil;
//            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//            log.screen = @"Wishlist - Parser error";
//            log.fragment = @"wishlistProducts:";
//            [[OFLogService new] sendLog:log];
//            
//            NSError *customError = [self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (failure) failure(customError);
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success) success (products);
//            });
//        }
//    } failure:^(NSError *error, NSData *data) {
//        LogError *log = [LogError new];
//        log.absolutRequest = url.absoluteString;
//        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
//        log.data = data;
//        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//        log.screen = @"Wishlist";
//        log.fragment = @"wishlistProducts:";
//        [[OFLogService new] sendLog:log];
//        
//        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeProducts];
//        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//           if (failure) failure(customError);
//        });
//    }];
}

//
// Get favorited product skus
//
- (void)favoritedProducts:(void (^)(NSArray *favorites))success failure:(void (^)(NSError *error))failure
{
    
    [[WBRWishlist new] getWishlistSku:^(NSDictionary *dictWishlist) {
        
        NSArray *products = dictWishlist[@"skusIds"] ?: @[];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success (products);
        });
        
    } failure:^(NSError *error, NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(error);
        });
    }];
    
    /*
     NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLWishlistSkus]];
     NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringCacheData;
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutRequest];
     [request setHTTPMethod:@"GET"];
     [request setValue:guid.length > 0 ? guid : @"" forHTTPHeaderField:@"guid"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     
     [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response)
     {
     NSArray *products = json[@"wishlist"] ?: @[];
     dispatch_async(dispatch_get_main_queue(), ^{
     if (success) success (products);
     });
     }
     failure:^(NSError *error, NSData *data)
     {
     LogError *log = [LogError new];
     log.absolutRequest = url.absoluteString;
     log.code = [NSString stringWithFormat:@"%li", (long)error.code];
     log.data = data;
     log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
     log.screen = @"Home";
     log.fragment = @"favoriteProducts:";
     [[OFLogService new] sendLog:log];
     
     dispatch_async(dispatch_get_main_queue(), ^{
     if (failure) failure(error);
     });
     }];
     */
}

- (void)addProductWithSKU:(NSString *)productSKU productID:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error))completion
{
    
    [[WBRWishlist new] addWishlistProductWithSku:productSKU productId:productId sellerId:sellerId completion:^(BOOL success, NSError *error, NSData *data) {
        
        if (success) {
            
            [WALFavoritesCache insert:[[NSNumberFormatter new] numberFromString:productSKU]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": @[productId], @"wishlist": @YES}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion (YES, nil);
            });
        }
        else {
            
            if (error.code == 409) {
                //The item is already in the list, so we should take care of changing the favorite status
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion (NO, error);
                });
                return;
            } else if (error.code == 422) {
                NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeAdd];
                NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion (NO, customError);
                });
                return;
            }
            
            NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeAdd];
            NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion (NO, customError);
            });
        }
    }];
    
//    NSURL *url = [NSURL URLWithString:_endpoint];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    NSDictionary *wishlistDictionary = @{@"skuId": productSKU ?: @"",
//                                         @"productId" : productId ? productId : @"",
//                                         @"sellerId" : sellerId ? sellerId : @""};
//    
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:wishlistDictionary options:0 error:nil];
//    [request setHTTPBody:postData];
//    
//    
//    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        [WALFavoritesCache insert:[[NSNumberFormatter new] numberFromString:productSKU]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": @[productId],
//                                                                                                      @"wishlist": @YES}];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) completion (YES, nil);
//        });
//    } failure:^(NSError *error, NSData *data) {
//        
//        if (error.code == 409) {
//            //The item is already in the list, so we should take care of changing the favorite status
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) completion (NO, error);
//            });
//            return;
//        } else if (error.code == 422) {
//            NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeAdd];
//            NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) completion (NO, customError);
//            });
//            return;
//        }
//
//        LogError *log = [LogError new];
//        log.absolutRequest = url.absoluteString;
//        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
//        log.data = data;
//        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//        log.screen = @"Wishlist";
//        log.fragment = @"addProduct:";
//        [[OFLogService new] sendLog:log];
//        
//        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeAdd];
//        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) completion (NO, customError);
//        });
//    }];
}

- (void)removeProductWithSKU:(NSString *)productSKU productId:(NSString *)productId completion:(void (^)(BOOL, NSError *))completion
{
    [[WBRWishlist new] delWishlistProductWithSku:@[productSKU] success:^(NSData *data) {
        
        [WALFavoritesCache remove:[[NSNumberFormatter new] numberFromString:productSKU]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": @[productId],
                                                                                                      @"wishlist": @NO}];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion (YES, nil);
        });

        
    } failure:^(NSError *error, NSData *dataError) {
        
        if (error.code == 409)
        {
            //The item is already off the list, so we should take care of changing the favorite status
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion (YES, nil);
            });
            return;
        } else if (error.code == 422) {
            NSString *errorMessage = [self errorMessageForResponseData:dataError requestType:RequestTypeAdd];
            NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion (NO, customError);
            });
            return;
        }
        
        NSString *errorMessage = [self errorMessageForResponseData:dataError requestType:RequestTypeRemove];
        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion (NO, customError);
        });
    }];
    
//    NSDictionary *productsSKUDict = @{@"skus" : @[productSKU]};
//    NSData *deleteData = [NSJSONSerialization dataWithJSONObject:productsSKUDict options:0 error:nil];
//    
//    NSURL *url = [NSURL URLWithString:[_endpoint stringByAppendingString:@"/delete"]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
//    [request setHTTPMethod:@"PUT"];
//    [request setHTTPBody:deleteData];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    
    
//    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        [WALFavoritesCache remove:[[NSNumberFormatter new] numberFromString:productSKU]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": @[productId],
//                                                                                                      @"wishlist": @NO}];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) completion (YES, nil);
//        });
//    } failure:^(NSError *error, NSData *data) {
//        
//        if (error.code == 409)
//        {
//            //The item is already off the list, so we should take care of changing the favorite status
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) completion (YES, nil);
//            });
//            return;
//        }
//
//        LogError *log = [LogError new];
//        log.absolutRequest = url.absoluteString;
//        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
//        log.data = data;
//        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//        log.screen = @"Wishlist";
//        log.fragment = @"removeProduct:";
//        [[OFLogService new] sendLog:log];
//        
//        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeRemove];
//        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) completion (NO, customError);
//        });
//    }];
}

- (void)removeProductsWithSKUs:(NSArray *)productsSKUs productsIds:(NSString *)productsIds success:(void (^)(WishlistModel *))success failure:(void (^)(NSError *))failure {
    
    [[WBRWishlist new] delWishlistProductWithSku:productsSKUs success:^(NSData *data) {
        
        NSError *parserError;
        WishlistModel *wishlist = [[WishlistModel alloc] initWithData:data error:&parserError];
        
        if (parserError) {
            NSError *customError = [self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(customError);
            });
        }
        else {
            
            [WALFavoritesCache removeSKUs:productsSKUs];
            [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": productsIds,
                                                                                                          @"wishlist": @NO}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success (wishlist);
            });
        }
    } failure:^(NSError *error, NSData *dataError) {
        
        NSString *errorMessage = [self errorMessageForResponseData:dataError requestType:RequestTypeRemove];
        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(customError);
        });
    }];
    
//    NSDictionary *productsSKUDict = @{@"skus" : productsSKUs};
//    NSData *deleteData = [NSJSONSerialization dataWithJSONObject:productsSKUDict options:0 error:nil];
//    
//    NSURL *url = [NSURL URLWithString:[_endpoint stringByAppendingString:@"/delete"]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
//    [request setHTTPMethod:@"PUT"];
//    [request setHTTPBody:deleteData];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    
//    
//    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        NSError *parserError;
//        WishlistModel *wishlist = [[WishlistModel alloc] initWithModelToJSONDictionary:json error:&parserError];
//        
//        if (parserError) {
//            LogError *log = [LogError new];
//            log.absolutRequest = url.absoluteString;
//            log.code = [NSString stringWithFormat:@"%ld", (long)parserError.code];
//            log.data = parserError.localizedDescription ? [parserError.localizedDescription dataUsingEncoding:NSUTF8StringEncoding] : nil;
//            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//            log.screen = @"Wishlist - Parser error";
//            log.fragment = NSStringFromSelector(@selector(removeProductsWithSKUs:productsIds:success:failure:));
//            [[OFLogService new] sendLog:log];
//            
//            NSError *customError = [self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (failure) failure(customError);
//            });
//        }
//        else {
//            [WALFavoritesCache removeSKUs:productsSKUs];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kWishlistNotificationName object:@{@"productsIds": productsIds,
//                                                                                                          @"wishlist": @NO}];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success) success (wishlist);
//            });
//        }
//    } failure:^(NSError *error, NSData *data) {
//        LogError *log = [LogError new];
//        log.absolutRequest = url.absoluteString;
//        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
//        log.data = data;
//        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//        log.screen = @"Wishlist";
//        log.fragment = NSStringFromSelector(@selector(removeProductsWithSKUs:productsIds:success:failure:));
//        [[OFLogService new] sendLog:log];
//        
//        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeRemove];
//        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (failure) failure(customError);
//        });
//    }];
}

- (void)alreadyBoughtProductsWithSKUs:(NSArray *)productsSKUs success:(void (^)(WishlistModel *))success failure:(void (^)(NSError *))failure
{
    
    [[WBRWishlist new] boughtWishlistProductWithSku:productsSKUs success:^(NSData *data) {
        
        NSError *parserError;
        WishlistModel *wishlist = [[WishlistModel alloc] initWithData:data error:&parserError];
        
        if (parserError) {
            
            NSError *customError = [self errorWithMessage:WISHLIST_REQUEST_FEEDBACK_ERROR];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(customError);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success (wishlist);
            });
        }
    } failure:^(NSError *error, NSData *dataError) {
        
        NSString *errorMessage = [self errorMessageForResponseData:dataError requestType:RequestTypeSetBoughtState];
        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(customError);
        });
    }];
    
//    NSDictionary *productsSKUDict = @{@"skus" : productsSKUs,
//                                      @"bought" : @(YES)};
//    NSData *putData = [NSJSONSerialization dataWithJSONObject:productsSKUDict options:0 error:nil];
//    
//    NSURL *url = [NSURL URLWithString:_endpoint];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
//    [request setHTTPMethod:@"PUT"];
//    [request setHTTPBody:putData];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    
//    
//    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        NSError *parserError;
//        WishlistModel *wishlist = [[WishlistModel alloc] initWithModelToJSONDictionary:json error:&parserError];
//        
//        if (parserError) {
//            LogError *log = [LogError new];
//            log.absolutRequest = url.absoluteString;
//            log.code = [NSString stringWithFormat:@"%ld", (long)parserError.code];
//            log.data = parserError.localizedDescription ? [parserError.localizedDescription dataUsingEncoding:NSUTF8StringEncoding] : nil;
//            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//            log.screen = @"Wishlist - Parser error";
//            log.fragment = NSStringFromSelector(@selector(removeProductsWithSKUs:productsIds:success:failure:));
//            [[OFLogService new] sendLog:log];
//            
//            NSError *customError = [self errorWithMessage:WISHLIST_REQUEST_FEEDBACK_ERROR];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (failure) failure(customError);
//            });
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (success) success (wishlist);
//            });
//        }
//    } failure:^(NSError *error, NSData *data) {
//        LogError *log = [LogError new];
//        log.absolutRequest = url.absoluteString;
//        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
//        log.data = data;
//        log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
//        log.screen = @"Wishlist";
//        log.fragment = @"";
//        [[OFLogService new] sendLog:log];
//        
//        NSString *errorMessage = [self errorMessageForResponseData:data requestType:RequestTypeSetBoughtState];
//        NSError *customError = [NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (failure) failure(customError);
//        });
//    }];
}

- (NSString *)errorMessageForResponseData:(NSData *)data requestType:(RequestType)type
{
    if (!data) {
        return WISHLIST_GENERIC_ERROR;
    }
    
    NSString *message;
    switch (type)
    {
        case RequestTypeProducts:
            message = WISHLIST_PRODUCTS_ERROR;
            break;
        case RequestTypeAdd:
            message = WISHLIST_ADD_PRODUCT_ERROR;
            break;
        case RequestTypeRemove:
            message = WISHLIST_REMOVE_PRODUCT_ERROR;
            break;
        default:
            message = WISHLIST_GENERIC_ERROR;
            break;
    }
    
    NSError *error;
    NSDictionary *responseErrorDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSString *errorType;
    NSString *errorMessage;
    
    if (!error)
    {
        if ([responseErrorDictionary[@"cause"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *causeDictionary = responseErrorDictionary[@"cause"];
            if ([causeDictionary[@"message"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = causeDictionary[@"message"];
                errorType = errorDictionary[@"type"];
                errorMessage = errorDictionary[@"message"];
            } else {
                errorMessage = responseErrorDictionary[@"message"];
            }
        } else {
            errorMessage = responseErrorDictionary[@"message"];
        }
        
        NSArray *errors = responseErrorDictionary[@"errors"];
        
        if (errorType.length > 0) {
            LogInfo(@"Wishlist Error type: %@", errorType);
        }
        if (errorMessage.length > 0) {
            LogInfo(@"Wishlist Error Message: %@", errorMessage);
        }
        
        if (errors && errors.count > 0) {
            NSDictionary *errorMessageDictionary = errors.firstObject;
            errorMessage = errorMessageDictionary[@"message"];
            if (errorMessage.length > 0) {
                LogInfo(@"Wishlist Error Message: %@", errorMessage);
            }
        }
        
        if (type == RequestTypeAdd)
        {
            if (errorType.length > 0)
            {
                if ([errorType.lowercaseString isEqualToString:@"SKU_REQUIRED_FIELDS".lowercaseString]) {
                    message = WISHLIST_GENERIC_ERROR;
                }
                else if ([errorType.lowercaseString isEqualToString:@"SKU_ERROR_LIMIT".lowercaseString]) {
                    message = WISHLIST_SKU_ERROR_LIMIT;
                }
            }
        }
    }
    
    return (message.length > 0) ? message : WISHLIST_GENERIC_ERROR;
}

@end
