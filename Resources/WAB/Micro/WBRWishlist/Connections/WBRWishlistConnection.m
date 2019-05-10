//
//  WBRWishlistConnection.m
//  Walmart
//
//  Created by Marcelo Santos on 5/11/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRWishlistConnection.h"

#import "ErrorConnectionmanager.h"
#import "TimeManager.h"
#import "WBRUser.h"
#import "WishlistUrls.h"
#import "WBRUTM.h"

@implementation WBRWishlistConnection

- (void) requestBoughtWishProdSkusArray:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_WISHLIST_BOUGHT) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-bought" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success (jsonData);
    }
    else {
        
        if (productsSKUs.count > 0) {
            
            NSString *urlWithProductsSkus = [NSString stringWithFormat:@"%@/%@", URL_WISHLIST, [productsSKUs componentsJoinedByString:@","]];
            
            NSDictionary *dictParam = @{@"httpMethod" : @"PUT",
                                        @"url" : urlWithProductsSkus
                                        };
            
            [self requestWishlistContents:dictParam completion:^(NSDictionary *dictJson, NSData *data) {
                success (data);
            } failure:^(NSError *error, NSData *data) {
                failure (error, data);
            }];
        }
        else {
            
            NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:99 userInfo:@{NSLocalizedDescriptionKey : ERROR_UNKNOWN_CATEGORY}];
            failure (errorUnknown, nil);
        }
    }
}


- (void) requestDelWishProdSkusArray:(NSArray *)productsSKUs success:(void (^)(NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_WISHLIST_DEL) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-del" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Wishlist DEL: %@", dictJson);
        
        success (jsonData);
    }
    else {
     
        if (productsSKUs.count > 0) {
            
            NSString *urlWithProductsSkus = [NSString stringWithFormat:@"%@/%@", URL_WISHLIST, [productsSKUs componentsJoinedByString:@","]];
            
            NSDictionary *dictParam = @{@"httpMethod" : @"DELETE",
                                        @"url" : urlWithProductsSkus
                                        };
            
            [self requestWishlistContents:dictParam completion:^(NSDictionary *dictJson, NSData *data) {
                success (data);
            } failure:^(NSError *error, NSData *data) {
                failure (error, data);
            }];
        }
        else {
            
            NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:99 userInfo:@{NSLocalizedDescriptionKey : ERROR_UNKNOWN_CATEGORY}];
            failure (errorUnknown, nil);
        }
    }
}

- (void) requestAddWishlistProductWithSku:(NSString *)productSku productId:(NSString *)productId sellerId:(NSString *)sellerId completion:(void (^)(BOOL success, NSError *error, NSData *data))completion {
    
    if (USE_MOCK_WISHLIST_ADD) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-add" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Wishlist ADD: %@", dictJson);
        
        completion (YES, nil, nil);
    }
    else {
        
        if (productSku.intValue > 0 && productId.intValue > 0) {
            
            NSDictionary *wishlistDictionary = @{@"skuId": [NSNumber numberWithInt:productSku.intValue],
                                                 @"productId" : [NSNumber numberWithInt:productId.intValue],
                                                 @"sellerId" : sellerId ? sellerId : @""};
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:wishlistDictionary options:0 error:nil];
            
            NSDictionary *dictHeaders = @{@"content-type" : @"application/json"};
            
            NSDictionary *dictParam = @{@"httpMethod" : @"POST",
                                        @"url" : URL_WISHLIST,
                                        @"headers" : dictHeaders,
                                        @"postData" : postData
                                        };
            
            [self requestWishlistContents:dictParam completion:^(NSDictionary *dictJson, NSData *data) {
                completion (YES, nil, nil);
            } failure:^(NSError *error, NSData *data) {
                completion (NO, error, data);
            }];
        }
        else {
            
            NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:99 userInfo:@{NSLocalizedDescriptionKey : ERROR_UNKNOWN_CATEGORY}];
            completion (NO, errorUnknown, nil);
        }
    }
}

- (void) requestWishlist:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure {
    
    if (USE_MOCK_WISHLIST_GET) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Wishlist GET: %@", dictJson);
        
        success (dictJson);
    }
    else {
        
        NSDictionary *dictParam = @{@"httpMethod" : @"GET",
                                    @"url" : URL_WISHLIST
                                    };
        
        [self requestWishlistContents:dictParam completion:^(NSDictionary *dictJson, NSData *data) {
            success (dictJson);
        } failure:^(NSError *error, NSData *data) {
            failure (error, data);
        }];
    }
}


- (void) requestWishlistSku:(void (^)(NSDictionary *dictWishlist))success failure:(void (^)(NSError *error, NSData *data))failure {
    
    if (USE_MOCK_WISHLIST_SKU) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wish-skus" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Wishlist SKU: %@", dictJson);
        
        success (dictJson);
    }
    else {

        NSDictionary *dictParam = @{@"httpMethod" : @"GET",
                                    @"url" : URL_WISHLIST_SKU
                                    };
        
        [self requestWishlistContents:dictParam completion:^(NSDictionary *dictContent, NSData *data) {
            success (dictContent);
        } failure:^(NSError *error, NSData *dataError) {
            failure (error, dataError);
        }];
    }
}


- (void) requestWishlistContents:(NSDictionary *)dictParam completion:(void (^)(NSDictionary *dictContent, NSData *data))success failure:(void (^)(NSError *error, NSData *dataError))failure
{
    NSString *strUrl = [dictParam objectForKey:@"url"];
    NSURL *requestURL = [NSURL URLWithString:strUrl];
    
    requestURL = [WBRUTM addUTMQueryParameterTo:requestURL];
    LogMicro(@"[WISHLIST] URL: %@", requestURL.absoluteString);
    
    //Header Info
    NSDictionary *headers = [self mountHeaderWithParameters:dictParam];
    ////
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:[dictParam objectForKey:@"httpMethod"]];
    [request setAllHTTPHeaderFields:headers];
    LogMicro(@"[WISHLIST] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[WISHLIST] Header: %@", headers);
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:[dictParam objectForKey:@"postData"]];
        LogMicro(@"[WISHLIST] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }
    ////
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        [TimeManager updateServerDateWithResponse:httpResponse];
        
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[WISHLIST] Status Code: %i", responseStatusCode);
        
        //200
        if (responseStatusCode == 200) {
            
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            LogInfo(@"[REQUEST] Wishlist: %@", dictJson);
            success (dictJson, data);
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"[WISHLIST] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            });
        }
    }];
    
    [dataTask resume];
}


/**
 Automatic header for connection

 @param param NSDictionary with keys: httpMethod, url, headers(optional) and postData(optional).
 @return NSDictionary with complete header.
 */
- (NSDictionary *) mountHeaderWithParameters:(NSDictionary *) param {
    
    NSMutableDictionary *mutHeader = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"headers"] ?: @{}];
    
    __block NSString *guidUser = @"";
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[WBRUser new] guIDWithCompletionBlock:^(NSString *guid) {
        if (guid) {
            guidUser = guid;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [mutHeader setObject:guidUser forKey:@"guid"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
    [mutHeader setObject:version forKey:@"versionApp"];
    [mutHeader setObject:@"iOS" forKey:@"system"];
    
    return [NSDictionary dictionaryWithDictionary:mutHeader];
}


//- (void) requestWishlistContent:(NSString *)strUrl withDataBody:(NSData *)postData completion:(void (^)(NSDictionary *))success failure:(void (^)(NSError *error, NSData *data))failure
//{
//    
//    NSString *previousMethod = [self getCallerStackSymbol];
//    LogMicro(@"Previous Method: %@", previousMethod);
//    LogURL(@"URL: %@", strUrl);
//    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
//    
//    [[WBRUser new] guIDWithCompletionBlock:^(NSString *guid) {
//        
//        LogMicro(@"[WISHLIST] Guid: %@", guid);
//        
//        if (guid.length > 0) {
//            
//            NSDictionary *headers = @{
//                                      @"versionApp": version,
//                                      @"system": @"iOS",
//                                      @"guid": guid
//                                      };
//            
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
//                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                               timeoutInterval:timeoutRequest];
//            
//            [request setHTTPMethod:@"GET"];
//            
//            if (postData) {
//                
//                NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:headers];
//                [dictTemp setObject:@"application/json" forKey:@"content-type"];
//
//                [request setHTTPMethod:@"POST"];
//                [request setHTTPBody:postData];
//                
//                headers = [NSDictionary dictionaryWithDictionary:dictTemp];
//            }
//            
//            [request setAllHTTPHeaderFields:headers];
//            
//            LogMicro(@"[WISHLIST] Header: %@", headers);
//            
//            NSURLSession *session = [NSURLSession sharedSession];
//            
//            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                
//                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
//                LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
//                
//                //200
//                if (responseStatusCode == 200) {
//                    
//                    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//                    LogInfo(@"[REQUEST] Wishlist: %@", dictJson);
//                    success (dictJson);
//                }
//                else {
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
//                        LogMicro(@"[%@] DictError: %@", previousMethod, dictError);
//                        
//                        NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
//                        
//                        failure (errorUnknown, data);
//                    });
//                }
//            }];
//            
//            [dataTask resume];
//        }
//        else {
//            
//            NSData *data = [NSData new];
//            
//            NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.ofertas" code:99 userInfo:@{NSLocalizedDescriptionKey : ERROR_UNKNOWN_CATEGORY}];
//            
//            failure (errorUnknown, data);
//        }
//    }];
//}


- (NSString *)getCallerStackSymbol {
    
    NSString *callerStackSymbol = @"Could not track caller stack symbol";
    
    NSArray *stackSymbols = [NSThread callStackSymbols];
    if(stackSymbols.count >= 2) {
        callerStackSymbol = [stackSymbols objectAtIndex:2];
        if(callerStackSymbol) {
            NSMutableArray *callerStackSymbolDetailsArr = [[NSMutableArray alloc] initWithArray:[callerStackSymbol componentsSeparatedByString:@" "]];
            NSUInteger callerStackSymbolIndex = callerStackSymbolDetailsArr.count - 3;
            if (callerStackSymbolDetailsArr.count > callerStackSymbolIndex && [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex]) {
                callerStackSymbol = [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex];
                callerStackSymbol = [callerStackSymbol stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
        }
    }
    
    return callerStackSymbol;
}

@end
