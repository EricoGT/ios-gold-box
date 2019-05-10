//
//  CartConnection.m
//  Walmart
//
//  Created by Renan Cargnin on 07/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "CartConnection.h"

#import "WMParser.h"
#import "WMTokens.h"
#import "WMBCartManager.h"
#import "NSString+Cookies.h"
#import "WBRUTM.h"

@implementation CartConnection

+ (void)parseCartAndToken:(NSDictionary *)json {
    NSString *checkoutToken;
    NSString *cartId;
    
    NSArray *cookies = [json valueForKey:@"cookies"];
    for (NSString *cookie in cookies) {
        if (cartId.length == 0) {
            cartId = [cookie cookieValueForKey:@"cart"];
        }
        if (checkoutToken.length == 0) {
            checkoutToken = [cookie cookieValueForKey:@"token"];
        }
    }
    
    if (cartId.length > 0) [[WMTokens new] addCartId:cartId];
    if (checkoutToken.length > 0) [[WMTokens new] addTokenCheckout:checkoutToken];
}

+ (void)updateProductWithBody:(NSDictionary *)bodyDict successBlock:(void (^)(NSDictionary *cart, NSDictionary *errorDict))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    NSString *tkCk = [[WMTokens new] getTokenCheckout];
    NSString *cartId = [[WMTokens new] getCartId];
    
    NSURL *url = [NSURL URLWithString:URL_CART_UPDPRODUCT];
    url = [WBRUTM addUTMQueryParameterTo:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:tkCk forHTTPHeaderField:@"token"];
    [request setValue:cartId forHTTPHeaderField:@"cart"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:NULL]];
    [[WMBaseConnection new] run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        [CartConnection parseCartAndToken:json];
        if (successBlock) successBlock(json, nil);
    } failure:^(NSError *error, NSData *data) {
        NSError *jsonError;
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [CartConnection parseCartAndToken:json];
        
        NSDictionary *cart;
        NSArray *errors = json[@"errors"];
        if (errors.count > 0) {
            NSDictionary *errorDictionary = errors[0];
            NSDictionary *message = errorDictionary[@"message"];
            if (message) {
                NSDictionary *errorMap = message[@"errorMap"];
                if (errorMap) {
                    cart = errorMap[@"cart"];
                }
            }
        }
        
        if (error.code == 400 && cart) {
            NSDictionary *errorDict = [WMBCartManager getErrorCodeMsg:jsonString];
            
            NSArray *errorCodes = @[@"DELIVERY_NOT_POSSIBLE", @"PRODUCT_UNAVAILABLE"];
            NSArray *errorLevels = @[@"CART_LEVEL", @"ITEM_LEVEL"];
            
            NSString *errorCode = errorDict[@"errorCode"];
            NSString *errorLevel = errorDict[@"errorLevel"];
            
            if ([errorCodes containsObject:errorCode] || [errorLevels containsObject:errorLevel]) {
                if (successBlock) successBlock(cart, errorDict);
            }
            else {
                if (successBlock) successBlock(cart, nil);
            }
        }
        else {
            NSString *errorMessage;
            switch (error.code) {
                case 408:
                    errorMessage = ERROR_CONNECTION_TIMEOUT;
                    break;
                    
                case 0:
                    errorMessage = ERROR_CONNECTION_DATA;
                    break;
                    
                case 1009:
                    errorMessage = ERROR_CONNECTION_INTERNET;
                    break;
                    
                default:
                    errorMessage = ERROR_CONNECTION_UNKNOWN;
                    break;
            }
            if (failureBlock) failureBlock([WMBaseConnection errorWithCode:error.code message:errorMessage]);
        }
    }];
}

+ (NSDictionary *)requestBodyWithRedemptionCode:(NSString *)redemptionCode remove:(BOOL)remove {
    return @{@"giftCard": @{@"redemptionCode": redemptionCode ?: @"",
                            @"remove": @(remove)}};
}

+ (void)submitCouponWithRedemptionCode:(NSString *)redemptionCode successBlock:(void (^)(NSDictionary *cart, NSDictionary *errorDict))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    NSDictionary *couponBody = [CartConnection requestBodyWithRedemptionCode:redemptionCode remove:NO];
    [CartConnection updateProductWithBody:couponBody successBlock:^(NSDictionary *cart, NSDictionary *errorDict) {
        if (successBlock) successBlock(cart, errorDict);
    } failureBlock:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

+ (void)removeCouponWithRedemptionCode:(NSString *)redemptionCode successBlock:(void (^)(NSDictionary *cart, NSDictionary *errorDict))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    NSDictionary *couponBody = [CartConnection requestBodyWithRedemptionCode:redemptionCode remove:YES];
    [CartConnection updateProductWithBody:couponBody successBlock:^(NSDictionary *cart, NSDictionary *errorDict) {
        if (successBlock) successBlock(cart, errorDict);
    } failureBlock:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

@end
