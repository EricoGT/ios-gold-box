//
//  WBRUser.m
//  Walmart
//
//  Created by Marcelo Santos on 2/8/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRUser.h"
#import "WBRLoginManager.h"
#import "WALFavoritesCache.h"
#import "WALHomeCache.h"
#import "WMMyAccountViewController.h"
#import "WBRUserManager.h"
#import "WBRFacebookLoginManager.h"
@implementation WBRUser

- (FXKeychain *)keychainAccess
{
    return [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
}

#pragma mark - User GUID

- (void)guIDWithCompletionBlock:(void (^)(NSString *guid))completion
{
    
    if ([self isAuthenticated]) {
    
        FXKeychain *keychainItem = self.keychainAccess;
        __block NSString *guid = [keychainItem objectForKey:kGUIDkey];
        if (guid.length > 0)
        {
            if (completion) completion(guid);
        }
        else
        {
            [self tryGetContentFromUser:^(User *userPersonalData) {
                guid = userPersonalData.guid;
                [keychainItem setObject:guid forKey:kGUIDkey];
                if (completion) completion(guid);
                
            } failure:^(NSError *error) {
                if (completion) completion(nil);
            }];
        }
    }
    else{
        
        if (completion) completion(nil);
    }
}

+ (NSString *)guid {
    
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    __block NSString *guid = [keychainItem objectForKey:kGUIDkey];
    return guid;
}

#pragma mark - User PID

+ (NSString *)pid {
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    __block NSString *pid = [keychainItem objectForKey:kPIDkey];
    return pid;
}

#pragma mark - Remove user PID

+ (void)removePIDFromUser {
    
    LogInfo(@"PID   R E M O V E D");
    
//    //Delete all keychain Items
//    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
//                                (__bridge id)kSecClassInternetPassword,
//                                (__bridge id)kSecClassCertificate,
//                                (__bridge id)kSecClassKey,
//                                (__bridge id)kSecClassIdentity];
//    for (id secItemClass in secItemClasses) {
//        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
//        SecItemDelete((__bridge CFDictionaryRef)spec);
//    }
    
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    [keychainItem removeObjectForKey:kPIDkey];
    
//    FXKeychain *keychainItem = self.keychainAccess;
//    [keychainItem removeObjectForKey:kPIDkey];
    
    //List all keychain
//    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
//                                  (__bridge id)kSecMatchLimitAll, (__bridge id)kSecMatchLimit,
//                                  nil];
//    
//    NSArray *secItemClasses = [NSArray arrayWithObjects:
//                               (__bridge id)kSecClassGenericPassword,
//                               (__bridge id)kSecClassInternetPassword,
//                               (__bridge id)kSecClassCertificate,
//                               (__bridge id)kSecClassKey,
//                               (__bridge id)kSecClassIdentity,
//                               nil];
//    
//    for (id secItemClass in secItemClasses) {
//        [query setObject:secItemClass forKey:(__bridge id)kSecClass];
//        
//        CFTypeRef result = NULL;
//        SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
//        LogInfo(@"Keychain WBRUser:\n%@", (__bridge id)result);
//        if (result != NULL) CFRelease(result);
//    }
    
}

#pragma mark - Try get info from user

- (void) tryGetContentFromUser:(void (^)(User *userPersonalData))completion failure:(void (^)(NSError *error))failure {
    
    [WBRLoginManager loadUserInfoDataWithSuccessBlock:^(User *user) {
        if (completion) {
            completion(user);
        }

    } failureBlock:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - User First Name

- (void)firstNameWithCompletionBlock:(void (^)(NSString *firstName))completion
{
    
    if ([self isAuthenticated]) {
        
        __block NSString *firstName = [User sharedUser].firstName;
        
        if (firstName.length > 0)
        {
            if (completion) completion(firstName);
        }
        else
        {
            [self tryGetContentFromUser:^(User *userPersonalData) {
                firstName = userPersonalData.firstName;
                if (completion) completion(firstName);
            } failure:^(NSError *error) {
                if (completion) completion(nil);
            }];
        }
        
    } else {
        
        if (completion) completion(nil);
    }
}

#pragma mark - User Full Name

- (void)fullNameWithCompletionBlock:(void (^)(NSString *fullName))completion
{
    
    if ([self isAuthenticated]) {
        
        __block NSString *fullName = [User sharedUser].fullName;
        
        if (fullName.length > 0)
        {
            if (completion) completion(fullName);
        }
        else
        {
            [self tryGetContentFromUser:^(User *userPersonalData) {
                fullName = userPersonalData.fullName;
                if (completion) completion(fullName);
            } failure:^(NSError *error) {
                if (completion) completion(nil);
            }];
        }
        
    } else {
        
        if (completion) completion(nil);
    }
}

#pragma mark - User Nick Name

- (void)nickNameWithCompletionBlock:(void (^)(NSString *nickName))completion
{
    
    if ([self isAuthenticated]) {
        
        __block NSString *nickName = [User sharedUser].nickname;
        
        if (nickName.length > 0)
        {
            if (completion) completion(nickName);
        }
        else
        {
            [self tryGetContentFromUser:^(User *userPersonalData) {
                nickName = userPersonalData.nickname;
                if (completion) completion(nickName);
            } failure:^(NSError *error) {
                if (completion) completion(nil);
            }];
        }
        
    } else {
        
        if (completion) completion(nil);
    }
}

#pragma mark - Logout User

+ (void) logoutUserFromDevice {
    
    [self removePIDFromUser];
    [WBRUserManager logoutUser];
    [[WALMenuViewController singleton] logoutAndShowHome:NO];
    [FlurryWM logTracking_event_logout];
    [[WMTokens new] deleteTokenOAuth];
    [WALFavoritesCache clean];
    [WALHomeCache clean];
    [[WMMyAccountViewController new] willLogoutNotification];
    [WBRFacebookLoginManager logoutFacebook];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"showcaseHeart"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchHeart"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetWishlistStatus" object:nil];
}


- (BOOL)isAuthenticated
{
    WMBTokenModel *tokenV2 = [[WMTokens new] getTokenOAuthWithoutRefreshToken];
    BOOL hasTokenV2 = (tokenV2 && tokenV2.accessToken.length > 0);
    if (hasTokenV2) return YES;
    
    BOOL hasTokenV1 = [MDSSqlite hasOldToken];
    if (hasTokenV1) return YES;
    
    return NO;
}

@end
