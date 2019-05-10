//
//  WMTokens.m
//  Walmart
//
//  Created by Marcelo Santos on 5/31/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMTokens.h"
#import "MDSSqlite.h"
#import "WMParser.h"
#import "FXKeychain.h"
#import "WMBaseConnection.h"
#import "WMBTokenModel.h"
#import "WBRConnection.h"

static NSString *const WMBTOKEN_KEY = @"kWMBTokenKey";

@interface WMTokens ()

@end

@implementation WMTokens

- (BOOL)isAuthenticated
{
    WMBTokenModel *token = [WMTokens.keychain objectForKey:WMBTOKEN_KEY];
    return (token) ? YES : NO;
}

- (WMBTokenModel *)getTokenOAuthWithoutRefreshToken
{
    WMBTokenModel *token = [WMTokens.keychain objectForKey:WMBTOKEN_KEY];
    return (token) ? token : nil;
}

- (BOOL)addTokenOAuth:(WMBTokenModel *)token
{
    if (token)
    {
        BOOL success = [WMTokens.keychain setObject:token forKey:WMBTOKEN_KEY];
        return success;
    }
    return false;
}

- (void)getTokenOAuth:(void (^)(NSString *token))completion
{
    WMBTokenModel *token = [WMTokens.keychain objectForKey:WMBTOKEN_KEY];
    if (token)
    {
        if (token.isExpired)
        {
            [self refreshToken:token completion:^(WMBTokenModel *newToken)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(newToken ? newToken.accessToken : nil);
                });
            }];
        }
        else
        {
            if (completion) completion(token.accessToken);
        }
    }
    else
    {
        if (completion) completion(nil);
    }
}


- (void)getTokenOAuthForceExpired:(void (^)(NSString *token))completion
{
    WMBTokenModel *token = [WMTokens.keychain objectForKey:WMBTOKEN_KEY];
    if (token)
    {
        [self refreshToken:token completion:^(WMBTokenModel *newToken)
        {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [newToken setExpiresIn:0];
                 if (completion) completion(newToken ? newToken.accessToken : nil);
             });
        }];
    }
    else
    {
        if (completion) completion(nil);
    }
}


- (BOOL)deleteTokenOAuth
{
    BOOL success = [WMTokens.keychain removeObjectForKey:WMBTOKEN_KEY];
    return success;
}

- (BOOL)addTokenCheckout:(NSString *)token
{
    MDSSqlite *sq = [MDSSqlite new];
    [sq deleteAllTokenCheckout];
    BOOL success = [sq addTokenCheck:token];
    return success;
}

- (NSString *)getTokenCheckout
{
    MDSSqlite *sq = [MDSSqlite new];
    NSString *strCheck = [sq getTokenCheck];

    LogInfo(@"=================================================================");
    LogInfo(@"Token Checkout: %@", strCheck);
    LogInfo(@"=================================================================");

    return strCheck;
}

- (BOOL)deleteTokenCheckout:(NSString *)token
{
    MDSSqlite *sq = [MDSSqlite new];
    BOOL success = [sq deleteAllTokenCheckout];
    return success;
}

#pragma mark - Cart
- (BOOL)addCartId:(NSString *)cart
{
    MDSSqlite *sq = [MDSSqlite new];
    [sq deleteAllCartId];
    BOOL success = [sq addCartId:cart];
    return success;
}

- (BOOL)deleteCartId:(NSString *)cart
{
    MDSSqlite *sq = [MDSSqlite new];
    BOOL success = [sq deleteAllCartId];
    return success;
}

- (NSString *)getCartId
{
    MDSSqlite *sq = [MDSSqlite new];
    NSString *strCartId = @"";
    if ([sq getCartId])
    {
        strCartId = [sq getCartId];
    }
    
    LogInfo(@"=================================================================");
    LogInfo(@"Cart Id #: %@", strCartId);
    LogInfo(@"=================================================================");

    if ([strCartId isEqualToString:@""])
    {
        LogInfo(@"=================================================================");
        LogInfo(@"Cart Id not available. Please, add product to cart first!!!");
        LogInfo(@"=================================================================");
    }
    return strCartId;
}

- (void)convertTokenToCheckoutWithCompletion:(void (^)())completion {
    
    [[WMTokens new] getTokenOAuth:^(NSString *token) {
        
        if (token) {
            
            __block NSString *tokenCheckout = @"";
            NSString *usrTok = token;
            if (![usrTok isEqualToString:@""]) {
                
                NSString *url = URL_CONVERT_TOKEN;
                
                NSDictionary *dictInfo = [OFSetup infoAppToServer];
                NSDictionary<NSString *, NSString *> *headersDictionary = @{
                                                    @"system": [dictInfo objectForKey:@"system"],
                                                    @"version": [dictInfo objectForKey:@"version"]
                                                    };
                
                [[WBRConnection sharedInstance] GET:url headers:headersDictionary authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
                    
                    NSString *file = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
                    tokenCheckout = [self parseCookie:file];
                    
                    if (completion) {
                        completion();
                    }
                } failureBlock:^(NSError *error, NSData *failureData) {
                    
                    NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
                    NSError *jsonError;
                    NSData *objectData = [file dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
                    if ([json objectForKey:@"responseCode"])
                    {
                        if ([[json objectForKey:@"responseCode"] intValue] == 401)
                        {
                            if (!self->_transparentError)
                            {
                                [self deleteTokenOAuth];
                            }
                        }
                    }
                    
                    [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_CONVERTTOKEN_ERR" andRequestUrl:@"" andRequestData:token andResponseCode:[NSString stringWithFormat:@"%i", (int)error.code] ?: @"" andResponseData:file andUserMessage:@"" andScreen:@"" andFragment:@"convertTokenToCheckout"];
                    
                    [FlurryWM logEvent_convertToken:@{@"response_code"   : [NSString stringWithFormat:@"%i", (int)error.code],
                                                      @"message"      :   [NSString stringWithFormat:@"%@/nToken: %@", file, token],
                                                      @"method"       :   @"convertTokenToCheckout",
                                                      @"screen"       :   @""}];
                    
                    if (completion) {
                        completion();
                    }
                }];
            }
            else {
                if (completion) {
                    completion();
                }
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[WALMenuViewController singleton] logoutAndShowHome:NO];
                
                if (completion) {
                    completion();
                }
            });
        }
    }];
}

- (NSString *)parseCookie:(NSString *)strCookie
{
    NSError *error = nil;
    NSData *jsonData = [strCookie dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObjects valueForKey:@"cookies"])
    {
        //If there is a cookie
        NSArray *arrElements = [jsonObjects valueForKey:@"cookies"];
        LogInfo(@"[WMTokens - parseCookie] Cart Elements from Cookie: %@", arrElements);
        
        NSArray *tokArr = [[arrElements objectAtIndex:0] componentsSeparatedByString:@";"];
        NSString *tok = [tokArr objectAtIndex:0];
        tok = [tok stringByReplacingOccurrencesOfString:@"token=" withString:@""];
        tok = [tok stringByReplacingOccurrencesOfString:@";" withString:@""];

        //Save Token
        [[WMTokens new] addTokenCheckout:tok];
        LogInfo(@"Token Converted: %@", tok);
        return tok;
    }
    else
    {
        //Or fill with old token and cart id
        NSString *tokId = [[WMTokens new] getTokenCheckout];
        [[WMTokens new] addTokenCheckout:tokId];
        return tokId;
    }
}

#pragma mark - Keychain
+ (FXKeychain *)keychain
{
    return [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
}

#pragma mark - Refresh Token
- (void)refreshTokenInBackground:(WMBTokenModel *)token
{
    [self refreshToken:token completion:nil];
}

- (void)refreshToken:(WMBTokenModel *)token completion:(void (^)(WMBTokenModel *newToken))completion
{
    NSURL *refreshTokenURL = [NSURL URLWithString:AUTH_URL];
    NSURLRequestCachePolicy cache = NSURLRequestReloadIgnoringLocalCacheData;

    NSString *postParameters = [NSString stringWithFormat:@"grant_type=refresh_token&refresh_token=%@",token.refreshToken ?: @""];
    NSData *postData = [postParameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    LogInfo(@"refresh token parameters: %@", [[NSString alloc] initWithData:postData encoding:
                                              NSUTF8StringEncoding]);
    
    LogInfo(@"\n");
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"        [REFRESHTOKEN] Parameters:");
    LogInfo(@"        [REFRESHTOKEN] %@", [[NSString alloc] initWithData:postData encoding:
                                                       NSUTF8StringEncoding]);
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"\n");

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:refreshTokenURL cachePolicy:cache timeoutInterval:timeoutRequest];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    LogInfo(@"\n");
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"        [REFRESHTOKEN] OLD Access Token: %@", token.accessToken);
    LogInfo(@"        [REFRESHTOKEN] OLD Refresh Token: %@", token.refreshToken);
    LogInfo(@"        --------------------------------------------------------------------");
    LogInfo(@"\n");
    

    [[WMBaseConnection new] run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response)
    {
        NSError *parserError;
        WMBTokenModel *token= [[WMBTokenModel alloc] initWithDictionary:json error:&parserError];
        if (!parserError)
        {
            [[WMTokens new] addTokenOAuth:token];
            
            //Show button to test refresh token
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
            //Notify status for debug
            [[NSNotificationCenter defaultCenter] postNotificationName:@"statusRefreshToken" object:nil];
#endif
            
            LogInfo(@"\n");
            LogInfo(@"        --------------------------------------------------------------------");
            LogInfo(@"        [REFRESHTOKEN] NEW Access Token: %@", token.accessToken);
            LogInfo(@"        [REFRESHTOKEN] NEW Refresh Token: %@", token.refreshToken);
            LogInfo(@"        --------------------------------------------------------------------");
            LogInfo(@"\n");

            if (completion) completion(token);
        }
        else
        {
            LogInfo(@"\n");
            LogInfo(@"        --------------------------------------------------------------------");
            LogInfo(@"        [REFRESHTOKEN] Parse Error");
            LogInfo(@"        --------------------------------------------------------------------");
            LogInfo(@"\n");
            
            if (completion) completion(nil);
        }
    }
    failure:^(NSError *error, NSData *data)
    {
        LogInfo(@"\n");
        LogInfo(@"        --------------------------------------------------------------------");
        LogInfo(@"        [REFRESHTOKEN] Unknown Error");
        LogInfo(@"        --------------------------------------------------------------------");
        LogInfo(@"\n");
        
        if (completion) completion(nil);
    }];
}

@end
