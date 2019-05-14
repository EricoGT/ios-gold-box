//
//  WALCache.h
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXKeychain.h"
@class HomeModel;

@interface WALCache : NSObject

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
 *  Returns the PID from the user logged
 *
 *  @param completion completion block with the pid if we have a valid one
 */
- (void)pIDWithCompletionBlock:(nullable void (^)(NSString * _Nullable))completion;

#pragma mark - Path
/**
 *  Returns the path to the system's cache folder
 *
 *  @return NSString with the path to system's cache folder
 */
- (nonnull NSString *)cachesPath;

#pragma mark - File Manager
/**
 *  Stores in the cache a NSData object with a specific identifier
 *
 *  @param data       NSData representing the object to save
 *  @param identifier Unique identifier representing this object
 *
 *  @return BOOL value indicating if the object was saved
 */
- (BOOL)storeCache:(nonnull NSData *)data withIdentifier:(nonnull NSString *)identifier;

/**
 *  Returns an NSData representing a saved object
 *
 *  @param identifier Unique identifier of the object
 *
 *  @return NSData with the contents of the object. May be nil
 */
- (nullable NSData *)cacheWithIdentifier:(nonnull NSString *)identifier;

/**
 *  Removes an object from the cache
 *
 *  @param identifier Unique identifier of the object
 */
- (void)removeCacheWithIdentifier:(nonnull NSString *)identifier;

/**
 *  Removes from the iCloud backup the file in path
 *
 *  @param filePath path of the file which you want to remove from iCloud backup
 */
- (void)removeFromIcloud:(nonnull NSURL *)filePath;

@end
