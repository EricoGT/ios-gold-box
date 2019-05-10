//
//  WBRLoginManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 29/10/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRLoginManager.h"
#import "WALFavoritesCache.h"
#import "WALTouchIDManager.h"
#import "PushHandler.h"
#import "WBRConnection.h"
#import "NSError+CustomError.h"

#define kDocumentKey @"document"
#define kEmailKey @"userName"

@implementation WBRLoginManager

+ (void)loginWithUser:(NSString *)user pass:(NSString *)pass isFacebook:(BOOL)isFacebook isFacebookWithLink:(BOOL)isFacebookWithLink snId:(NSString *)snId  successBlock:(void (^)())successBlock failureBlock:(void (^)(NSError *))failureBlock {
    [self loginWithUserKey:@"userName" userValue:user pass:pass isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snId successBlock:successBlock failureBlock:failureBlock];
}

+ (void)loginWithDocument:(NSString *)document pass:(NSString *)pass isFacebook:(BOOL)isFacebook isFacebookWithLink:(BOOL)isFacebookWithLink snId:(NSString *)snId successBlock:(void (^)())successBlock failureBlock:(void (^)(NSError *))failureBlock {
    [self loginWithUserKey:@"document" userValue:document pass:pass isFacebook:isFacebook isFacebookWithLink:isFacebookWithLink snId:snId successBlock:successBlock failureBlock:failureBlock];
}

+ (void)loginWithUserKey:(NSString *)userKey userValue:(NSString *)userValue pass:(NSString *)pass isFacebook:(BOOL)isFacebook isFacebookWithLink:(BOOL)isFacebookWithLink snId:(NSString *)snId successBlock:(void (^)())successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    NSString *url = AUTH_URL;
    
    NSDictionary *body = @{@"grant_type": @"password",
                           @"client_id" : @"walmart_mobile",
                           userKey      : userValue ?: @"",
                           @"password"  : pass};
    
    if (isFacebook) {
        LogInfo(@"[FACE] Is a Facebook login");
        //Add other parameters
        if (snId.length > 0 && isFacebookWithLink) {
            
            body = @{
                     @"grant_type"  : @"password",
                     @"client_id"   : @"walmart_mobile",
                     userKey        : userValue ?: @"",
                     @"password"    : pass,
                     @"signinField" : userValue ?: @"",
                     @"snId"        : snId
                     };
        }
        else if (snId.length > 0) {
            
            body = @{
                     @"grant_type"  : @"password",
                     @"client_id"   : @"walmart_mobile",
                     userKey        : userValue ?: @"",
                     @"password"    : pass,
                     @"snId"        : snId
                     };
        }
    }

    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    [headerDict setValue:@"application/vnd.connect.token+json;charset=UTF-8" forKey:@"Content-Type"];
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    
    [[WBRConnection sharedInstance] POST:url headers:headerDict body:body authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        NSError *parserError;
        WMBTokenModel *tokenModel = [[WMBTokenModel alloc] initWithData:data error:&parserError];
        if (tokenModel) {
            //Storing data in Keychain to retrieve with TouchID
            [WALTouchIDManager storeUser:userValue password:pass];
            [[NSUserDefaults standardUserDefaults] setValue:userValue.length > 0 ? userValue : @"" forKey:@"lgUs"];
            
            BOOL savedSuccessfully = [[WMTokens new] addTokenOAuth:tokenModel];
            
            LogInfo(@"Token saved: %i", savedSuccessfully);
            if (savedSuccessfully) {
                WMTokens *tokenManager = [WMTokens new];
                tokenManager.transparentError = YES;
            }
            
            [WALFavoritesCache update];
            [[PushHandler singleton] registerForPushNotificationsOnWalmartServer];
            
            User *localUser = [User sharedUser];
            if (localUser == nil) {
                [self loadUserInfoDataWithSuccessBlock:nil failureBlock:nil];
            } else {
                NSString *localUserKey = [userKey isEqualToString:kEmailKey] ? @"email" : @"document";
                if (!localUser || ([localUser respondsToSelector:NSSelectorFromString(localUserKey)] && ![[localUser valueForKey:localUserKey] isEqualToString:userValue])) {
                    [User setSharedUser:nil];
                    [self loadUserInfoDataWithSuccessBlock:nil failureBlock:nil];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
                if (successBlock) {
                    successBlock();
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON];
                
                if (failureBlock) {
                    failureBlock(error);
                }
            });
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        [WALTouchIDManager cleanCredentials];
        
        NSString *responseCode = [NSString stringWithFormat:@"%ld", (long)error.code];
        NSString *message = error.localizedDescription;
        NSString *method = NSStringFromSelector(@selector(loginWithUserKey:userValue:pass:isFacebook:isFacebookWithLink:snId:successBlock:failureBlock:));
        
        NSDictionary *parameters = @{@"response_code" : responseCode, @"message" : message, @"method" : method};
        [FlurryWM logEvent_communication_error:parameters];
        
        LogError *log = [LogError new];
        log.absolutRequest = url;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = failureData;
        log.userMessage = error.localizedDescription;
        log.screen = @"Login";
        log.fragment = method;
        [[OFLogService new] sendLog:log];
        
        NSString *authenticationErrorMessage = LOGIN_ERROR_MESSAGE;
        if (failureData) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:failureData options:NSJSONReadingAllowFragments error:nil];
            NSArray *errors = [json objectForKey:@"errors"];
            
            if (errors.count > 0)
            {
                if (errors[0][@"message"])
                {
                    NSString *strMessage = [errors[0][@"message"] lowercaseString];
                    if ([strMessage rangeOfString:@"captcha"].location != NSNotFound) {
                        authenticationErrorMessage = ERROR_LOGIN_MAX_ATTEMPTS_REACHED;
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[WALMenuViewController singleton] setUserAuthenticated:NO];

            NSString *errorMessage = error.code == 400 ? authenticationErrorMessage : error.localizedDescription;
            NSError *newError = [NSError errorWithMessage:errorMessage];

            if (failureBlock) {
                failureBlock(newError);
            }
        });
    }];
}


+ (void)loadUserInfoDataWithSuccessBlock:(void (^)(User *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    NSString *url = [[OFUrls new] getURLPersonalData];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    [headerDict setValue:@"application/json" forKey:@"Content-Type"];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    
    
    [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        NSError *parseError;
        User *user = [[User alloc] initWithData:data error:&parseError];

        dispatch_async(dispatch_get_main_queue(), ^{
            [User setSharedUser:user];
        });
        if (successBlock) {
            successBlock(user);
        } else {
         NSError *error = [NSError errorWithMessage:REQUEST_ERROR];
         
            if (failureBlock) {
             failureBlock(error);
            }
            
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        NSError *errorMessage = [NSError errorWithMessage:REQUEST_ERROR];
        if (failureBlock) {
            failureBlock(errorMessage);
        }

    }];
}

#pragma mark - Reset Password

+ (void)resetPasswordWithEmail:(NSString *)email success:(void (^)(NSString *maskedEmail))success failure:(void (^)(NSError *error))failure {
    [self resetPasswordWithRequestBody:[NSString stringWithFormat:@"email=%@", email ?: @""] success:success failure:failure];
}

+ (void)resetPasswordWithDocument:(NSString *)document success:(void (^)(NSString *maskedEmail))success failure:(void (^)(NSError *error))failure {
    [self resetPasswordWithRequestBody:[NSString stringWithFormat:@"document=%@", document ?: @""] success:success failure:failure];
}

+ (void)resetPasswordWithRequestBody:(NSString *)requestBody success:(void (^)(NSString *maskedEmail))success failure:(void (^)(NSError *))failure {

    NSString *url = [[OFUrls new] getURLRequestPassword];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    [headerDict setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerDict setValue:@"application/x-www-form-urlencoded" forKey:@"Accept"];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];

    [[WBRConnection sharedInstance] POST:url headers:headerDict bodyString:requestBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            NSString *maskedEmail = json[@"email"];
            [WALTouchIDManager cleanCredentials];
            if (success) success(maskedEmail);
        });

    } failureBlock:^(NSError *error, NSData *failureData) {
        NSString *responseCode = [NSString stringWithFormat:@"%ld", (long)error.code];
        NSString *message = error.localizedDescription;
        NSString *method = NSStringFromSelector(@selector(resetPasswordWithRequestBody:success:failure:));
        
        NSDictionary *parameters = @{@"response_code" : responseCode, @"message" : message, @"method" : method};
        [FlurryWM logEvent_communication_error:parameters];
        
        LogError *log = [LogError new];
        log.absolutRequest = url;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = failureData;
        log.userMessage = error.localizedDescription;
        log.screen = @"Reset Password";
        log.fragment = method;
        [[OFLogService new] sendLog:log];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(error);
        });
    }];
}

#pragma mark - Register User

+ (void)registerUserWithUserInfoDict:(NSDictionary *)userInfoDict withFacebook:(BOOL)isFacebook andSnId:(NSString *)snId success:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSString *url = [[OFUrls new] getURLNewUser];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    [headerDict setValue:@"application/json" forKey:@"Content-Type"];
    [headerDict setValue:@"application/json" forKey:@"Accept"];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];
    if (isFacebook) {
        LogInfo(@"[CREATE ACCOUNT] Facebook login: TRUE");
        if (snId.length > 0) {
            [userInfo setObject:snId forKey:@"snId"];
        }
    }
    LogInfo(@"[CREATE ACCOUNT] Body dict after: %@", userInfo);

    NSData *postData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:nil];
    NSString* jsonRegister = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    LogInfo(@"[CREATE ACCOUNT] JSON Register: %@", jsonRegister);

    [[WBRConnection sharedInstance] POST:url headers:headerDict bodyString:jsonRegister authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        [FlurryWM logEvent_signup_success];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } failureBlock:^(NSError *error, NSData *failureData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:failureData options:NSJSONReadingAllowFragments error:nil];
        
        LogInfo(@"[CREATE ACCOUNT] ERRO: %@", json);
        LogInfo(@"[CREATE ACCOUNT] Erro na criação do usuario! :-( (%ld)", (long) error.code);
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_SIGNUP_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", url] andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%ld", (long) error.code] andResponseData:[[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding] andUserMessage:CREATE_USER_ERROR andScreen:@"" andFragment:NSStringFromSelector(@selector(registerUserWithUserInfoDict:withFacebook:andSnId:success:failure:))];
        
        if (json) {
            NSString *userErrorMessage;
            NSArray *errors = [json objectForKey:@"errors"];

            if (errors.count > 0) {
                if (errors[0][@"message"]) {
                    NSString *strMessage = [errors[0][@"message"] lowercaseString];
                    NSString *strSearch1 = @"exists";
                    NSString *strSearch2 = @"e-mail";
                    
                    if ([strMessage rangeOfString:strSearch1].location != NSNotFound && [strMessage rangeOfString:strSearch2].location != NSNotFound) {
                        userErrorMessage = EMAIL_ALREADY;
                    } else {
                        NSString *strSearch3 = @"exists";
                        NSString *strSearch4 = @"document";
                        
                        if ([strMessage rangeOfString:strSearch3].location != NSNotFound && [strMessage rangeOfString:strSearch4].location != NSNotFound) {
                            userErrorMessage = CPF_ALREADY;
                        } else {
                            if ([strMessage rangeOfString:@"captcha"].location != NSNotFound) {
                                userErrorMessage = REGISTER_ERROR_MAX_ATTEMPTS_REACHED;
                            }
                        }
                    }
                } else {
                    userErrorMessage = CREATE_USER_ERROR;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    NSError *errorMessage = [NSError errorWithMessage:userErrorMessage];
                    failure(errorMessage);
                }
            });
        } else {
            LogInfo(@"[CREATE ACCOUNT] Erro na criação do usuario! :-( (%d)", (int) error.code);
            LogErro(@"[CREATE ACCOUNT] Error response: %@", error.localizedDescription);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    NSError *errorMessage = [NSError errorWithMessage:CREATE_USER_ERROR];
                    failure(errorMessage);
                }
            });
        }
    }];
}


@end
