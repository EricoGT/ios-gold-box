//
//  WALCache.m
//  Walmart
//
//  Created by Bruno Delgado on 6/24/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALCache.h"
#import "WBRLoginManager.h"
#import "WishlistConnection.h"
#import "User.h"

@implementation WALCache

- (FXKeychain *)keychainAccess
{
    return [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
}

- (void)guIDWithCompletionBlock:(void (^)(NSString *guid))completion
{
    FXKeychain *keychainItem = self.keychainAccess;
    __block NSString *guid = [keychainItem objectForKey:kGUIDkey];
    if (guid.length > 0) {
        if (completion) {
            completion(guid);
        }
    } else {
        [WBRLoginManager loadUserInfoDataWithSuccessBlock:^(User *user) {
            guid = user.guid;
            [keychainItem setObject:guid forKey:kGUIDkey];
            if (completion) {
                completion(guid);
            }
        } failureBlock:^(NSError *error) {
            if (completion) {
                completion(nil);
            }
        }];
    }
}

- (void)pIDWithCompletionBlock:(void (^)(NSString *pid))completion
{
    FXKeychain *keychainItem = self.keychainAccess;
    __block NSString *pid = [keychainItem objectForKey:kPIDkey];
    if (pid.length > 0) {
        if (completion) {
            completion(pid);
        }
    } else {
        [WBRLoginManager loadUserInfoDataWithSuccessBlock:^(User *user) {
            pid = user.pid;
            [keychainItem setObject:pid forKey:kPIDkey];
            if (completion) {
                completion(pid);
            }
        } failureBlock:^(NSError *error) {
            if (completion) {
                completion(nil);
            }
        }];
    }
}

#pragma mark - Path
- (NSString *)cachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - File Manager
- (BOOL)storeCache:(nonnull NSData *)data withIdentifier:(nonnull NSString *)identifier
{
    BOOL save = NO;
    if (data && identifier)
    {
        NSString *path = [self.cachesPath stringByAppendingPathComponent:identifier];
        save = [data writeToFile:path atomically:YES];
        [self removeFromIcloud:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", path]]];
    }
    return save;
}

- (NSData *)cacheWithIdentifier:(NSString *)identifier
{
    if (!identifier) return nil;

    NSData *file = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self.cachesPath stringByAppendingPathComponent:identifier];
    if ([fileManager fileExistsAtPath:filePath])
    {
        file = [fileManager contentsAtPath:filePath];
    }
    return file;
}

- (void)removeCacheWithIdentifier:(NSString *)identifier
{
    if (identifier.length <= 0)  return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self.cachesPath stringByAppendingPathComponent:identifier];

    if ([fileManager fileExistsAtPath:filePath])
    {
        NSData *favoritesData = [fileManager contentsAtPath:filePath];
        if (favoritesData)
        {
            NSError *deleteError;
            [fileManager removeItemAtPath:filePath error:&deleteError];
        }
    }
}

- (void)removeFromIcloud:(nonnull NSURL *)filePath
{
    //Prevents file from being backed up by iCloud an by this specifies that the file should remain on device even in low storage situations
    //Documentation: https://developer.apple.com/icloud/documentation/data-storage/index.html
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath.absoluteString])
    {
        NSError *error = nil;
        [filePath setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    }
}

@end
