//
//  WMTokens.h
//  Walmart
//
//  Created by Marcelo Santos on 5/31/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMBTokenModel;

@interface WMTokens : NSObject

@property (nonatomic, assign) BOOL transparentError;

- (BOOL)isAuthenticated;
- (WMBTokenModel *)getTokenOAuthWithoutRefreshToken;
- (void)getTokenOAuthForceExpired:(void (^)(NSString *token))completion;
- (void)refreshTokenInBackground:(WMBTokenModel *)token;

- (void)getTokenOAuth:(void (^)(NSString *token))completion;
- (NSString *)getTokenCheckout;
- (NSString *)getCartId;

- (BOOL)addTokenOAuth:(WMBTokenModel *)token;
- (BOOL)deleteTokenOAuth;

- (BOOL)addTokenCheckout:(NSString *)token;
- (BOOL)deleteTokenCheckout:(NSString *)token;

- (BOOL)addCartId:(NSString *)cart;
- (BOOL)deleteCartId:(NSString *)cart;

- (void)convertTokenToCheckoutWithCompletion:(void(^)())completion;

@end
