//
//  WBRUserManager.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/21/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

@import AirshipKit;

#import "WBRUserManager.h"

#import "NSError+CustomError.h"
#import "PushHandler.h"
#import "WBRConnection.h"

#import <Crashlytics/Crashlytics.h>

@implementation WBRUserManager

+ (void)logoutUser {
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type":   @"application/x-www-form-urlencoded",
                                                                 @"Accept":         @"application/x-www-form-urlencoded",
                                                                 @"system":         [dictInfo objectForKey:@"system"],
                                                                 @"version":        [dictInfo objectForKey:@"version"]
                                                                 };
    
    NSString *url = URL_LOGOUT;
    
    NSString *bodyParameter = nil;
    NSString *dToUrban = [[UAirship push] deviceToken] ?: @"";
    if (dToUrban.length > 0) {
        bodyParameter = [NSString stringWithFormat:@"deviceId=%@", dToUrban];
    }
    
    [[WBRConnection sharedInstance] POST:url headers:headersDictionary bodyString:bodyParameter authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        [self logLogoutWithError:nil data:data response:response];
    } failureBlock:^(NSError *error, NSData *failureData) {
        [self logLogoutWithError:error data:failureData response:nil];
    }];
    
    [[PushHandler new] unregisterForPushNotificationsOnWalmartServer];
    
    MDSSqlite *sq = [MDSSqlite new];
    [sq deleteAllTokenCheckout];
    [sq deleteAllCartId];
    [sq cleanCart];
    [[WMTokens new] deleteTokenOAuth];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotificationName object:nil];
}

+ (void)updateUserWithUserPersonalData:(User *)user fromCompleteScreen:(BOOL)complete successBlock:(kUserManagerSuccessBlock)successBlock failureBlock:(kUserManagerFailureBlock)failureBlock {
    
    LogInfo(@"[WBRUserManager] updateUserWithUserPersonalData:fromCompleteScreen:successBlock:failureBlock:");
    
    NSString *url = [[OFUrls new] getURLUpdateUser];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary *headerDictionary = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       @"system" : dictInfo[@"system"],
                                       @"version" : dictInfo[@"version"]
                                       };
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[user toDictionaryForUpdateServer]];
    if (!complete) {
        [userInfo removeObjectForKey:@"document"];
    }
    
    [[WBRConnection sharedInstance] PUT:url headers:headerDictionary body:userInfo authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        LogInfo(@"[WBRUserManager] updateUserWithUserPersonalData:fromCompleteScreen:successBlock:failureBlock: successBlock");
        
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        LogInfo(@"[WBRUserManager] updateUserWithUserPersonalData:fromCompleteScreen:successBlock:failureBlock: failureBlock");
        
        error = [self updateUserErrorWithError:error andData:failureData];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)changeUserPasswordWithNewPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword successBlock:(kUserManagerSuccessBlock)successBlock failureBlock:(kUserManagerFailureBlock)failureBlock {
    
    NSString *url = [[OFUrls new] getURLChangePassword];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary *headerDictionary = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       @"system" : dictInfo[@"system"],
                                       @"version" : dictInfo[@"version"]
                                       };
    NSDictionary *bodyDictionary = @{
                                     @"newPassword" : newPassword,
                                     @"newPasswordCheck" : newPassword,
                                     @"oldPassword" : oldPassword
                                     };
    
    [[WBRConnection sharedInstance] PUT:url headers:headerDictionary body:bodyDictionary authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        if (successBlock) {
            successBlock();
        }
        
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        error = [NSError errorWithCode:error.code message:CHANGE_PASSWORD_ERROR];
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Log

+ (void)logLogoutWithError:(NSError *)error data:(NSData *)data response:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpRespose = (NSHTTPURLResponse *)response;
    
    if ([data length] > 0 && error == nil) {
        
        if (httpRespose.statusCode == 200) {
            
            static dispatch_once_t oncePredicate;
            dispatch_once(&oncePredicate, ^{
                [Answers logSignUpWithMethod:@"logoutUser" success:@YES customAttributes:@{}];
            });
        }
        else {
            
            NSString *strResponse = [NSString stringWithFormat:@"logoutUser FAIL - [%i]", (int) httpRespose.statusCode];
            
            static dispatch_once_t oncePredicate;
            dispatch_once(&oncePredicate, ^{
                [Answers logSignUpWithMethod:strResponse success:@NO customAttributes:@{}];
            });
        }
    }
    else {
        
        if (httpRespose.statusCode != 200) {
            
            NSString *strResponse = [NSString stringWithFormat:@"logoutUser ERROR - [%i]", (int) httpRespose.statusCode];
            
            static dispatch_once_t oncePredicate;
            dispatch_once(&oncePredicate, ^{
                [Answers logSignUpWithMethod:strResponse success:@NO customAttributes:@{}];
            });
        }
        else {
            
            static dispatch_once_t oncePredicate;
            dispatch_once(&oncePredicate, ^{
                [Answers logSignUpWithMethod:@"logoutUser"
                                     success:@YES
                            customAttributes:@{}];
            });
        }
    }
}

#pragma mark - Error

+ (NSError *)updateUserErrorWithError:(NSError *)error andData:(NSData *)responseData {
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:kCFStringEncodingUTF8];
    
    if (responseData.length > 0) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError) {
            error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_SAVE failureReason:responseString];
        }
        else {
            
            if (error.code == 400) {
                if ([[json objectForKey:@"name"] isEqualToString:@"ValidationError"]) {
                    
                    if ([json objectForKey:@"errors"]) {
                        
                        NSArray *arrErrors = [json objectForKey:@"errors"];
                        if (arrErrors.count > 0) {
                            
                            if ([[arrErrors objectAtIndex:0] objectForKey:@"message"]) {
                                
                                NSString *strMsgError = [[arrErrors objectAtIndex:0] objectForKey:@"message"];
                                
                                if ([strMsgError isEqualToString:@"Document already exists!"]) {
                                    error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_EXISTS failureReason:responseString];
                                }
                                else if ([strMsgError isEqualToString:@"Document invalid"]) {
                                    error = [NSError errorWithCode:error.code message:INVALID_DOCUMENT failureReason:responseString];
                                }
                                else if ([strMsgError isEqualToString:@"must be in the past"]) {
                                    error = [NSError errorWithCode:error.code message:INVALID_BIRTHDAY failureReason:responseString];
                                }
                                else if ([strMsgError isEqualToString:@"Phone number invalid."]) {
                                    error = [NSError errorWithCode:error.code message:INVALID_PHONE failureReason:responseString];
                                }
                                else {
                                    error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_SAVE failureReason:responseString];
                                }
                            }
                        }
                    }
                    else {
                        error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_SAVE failureReason:responseString];
                    }
                }
            }
            else {
                error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_SAVE failureReason:responseString];
            }
        }
    }
    else {
        error = [NSError errorWithCode:error.code message:PERSONAL_DATA_ERROR_SAVE failureReason:responseString];
    }
    
    return error;
}

@end
