//
//  WALTouchIDManager.h
//  Walmart
//
//  Created by Bruno Delgado on 2/25/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALTouchIDManager : NSObject

/**
 *  Checks whether or not TouchID is available for this device and also if we have the login and pass stored to login with.
 *
 *  @return BOOL value indicating if we can rely on TouchID to validate
 */
+ (BOOL)canUseTouchID;

/**
 *  Authenticate using TouchID
 *
 *  @param completion BOOL indicating if the authentications was or not successfully
 */
+ (void)authenticateWithCompletionBlock:(void (^)(BOOL success))completion;

/**
 *  Stores a user in the keychain to use with Touch Id
 *
 *  @param user user to check when using Touch Id
 *  @param pass password to check when using Touch Id
 */
+ (void)storeUser:(NSString *)user password:(NSString *)password;

/**
 *  Updates a password from a previously saved user
 *
 *  @param newPassword new password to check when using Touch Id
 */
+ (void)updatePassword:(NSString *)newPassword;

/**
 *  Clean saved credentials from keychain
 */
+ (void)cleanCredentials;

@end
