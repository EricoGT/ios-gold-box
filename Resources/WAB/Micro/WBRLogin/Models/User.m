//
//  User.m
//  Walmart
//
//  Created by Bruno Delgado on 2/24/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "User.h"

#import "FXKeychain.h"

#define kUserDataKey @"userData"

static User *sharedUser = nil;

@implementation User

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"hasDocument"] || [propertyName isEqualToString:@"hasPhone"];
}

+ (User *)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FXKeychain *keychain = [FXKeychain defaultKeychain];
        User *user = [keychain objectForKey:kUserDataKey];
        if (user) {
            sharedUser = user;
        }
    });
    return sharedUser;
}

+ (void)setSharedUser:(User *)user {
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    if (user) {
        [keychain setObject:user forKey:kUserDataKey];
        
        FXKeychain *fxk =  [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
        [fxk setObject:user.guid forKey:kGUIDkey];
        [fxk setObject:user.pid forKey:kPIDkey];
        
    }
    else {
        [keychain removeObjectForKey:kUserDataKey];
        
        FXKeychain *fxk =  [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
        [fxk removeObjectForKey:kGUIDkey];
        [fxk removeObjectForKey:kPIDkey];
    }
    sharedUser = user;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSharedUserChangedNotificationName object:nil];
}

+ (void)persist
{
    User *user = [User sharedUser];
    if (user) {
        [User setSharedUser:user];
    }
}

- (BOOL)hasDocument
{
    return (self.document && self.document.length > 0);
}

- (BOOL)hasPhone
{
    return self.phones.count > 0;
}

- (NSDictionary *)toDictionaryForUpdateServer {
    
    NSMutableDictionary *newInfosMutable = [NSMutableDictionary dictionaryWithDictionary:[self toDictionary]];
    
    if ([newInfosMutable objectForKey:@"document"] == nil || [[newInfosMutable objectForKey:@"document"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"document"];
    }
    if ([newInfosMutable objectForKey:@"phones"] == nil || [[newInfosMutable objectForKey:@"phones"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"phones"];
    }
    if ([newInfosMutable objectForKey:@"firstName"] == nil || [[newInfosMutable objectForKey:@"firstName"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"firstName"];
    }
    if ([newInfosMutable objectForKey:@"preferences"] == nil || [[newInfosMutable objectForKey:@"preferences"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"preferences"];
    }
    if ([newInfosMutable objectForKey:@"email"] == nil || [[newInfosMutable objectForKey:@"email"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"email"];
    }
    if ([newInfosMutable objectForKey:@"dateBirth"] == nil || [[newInfosMutable objectForKey:@"dateBirth"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"dateBirth"];
    }
    if ([newInfosMutable objectForKey:@"lastName"] == nil || [[newInfosMutable objectForKey:@"lastName"] isEqual:[NSNull null]]) {
        [newInfosMutable removeObjectForKey:@"lastName"];
    }
    
    return newInfosMutable;
}

@end
