//
//  WBRUser.h
//  Walmart
//
//  Created by Marcelo Santos on 2/8/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXKeychain.h"
#import "User.h"

@interface WBRUser : NSObject

#pragma mark - Keychain
/**
 *  Returns a current instance of FXKeychain to help using keychain
 *
 *  @return Instance of FXKeychain with correct service and access group
 */
- (nonnull FXKeychain *)keychainAccess;

/**
 *  Returns the GUID from the user logged
 *
 *  @param completion completion block with the guid if we have a valid one
 */
- (void)guIDWithCompletionBlock:(nullable void (^)(NSString * _Nullable))completion;

/**
 *  Returns the GUID from the user logged
 *
 *  @param completion completion block with the guid if we have a valid one
 */
+ (NSString * _Nullable)guid;

/**
 *  Returns the PID from the user logged
 *
 *  @param completion completion block with the pid if we have a valid one
 */
+ (NSString * _Nullable)pid;

/**
 *  Returns status from the user if is logged or not
 *
 */
- (BOOL)isAuthenticated;

/**
 *  Remove user PID from keychain
 *
 */
+ (void)removePIDFromUser;

/**
 *  Retrieve full name from user
 *
 */
- (void)fullNameWithCompletionBlock:(nullable void (^)(NSString * _Nullable))completion;

/**
 *  Retrieve first name from user
 *
 */
- (void)firstNameWithCompletionBlock:(nullable void (^)(NSString * _Nullable))completion;

/**
 *  Retrieve nick name from user
 *
 */
- (void)nickNameWithCompletionBlock:(nullable void (^)(NSString * _Nullable))completion;

/**
 *  Logout user from device
 *
 */
+ (void) logoutUserFromDevice;

@end
