//
//  UserSession.m
//  Tracking
//
//  Created by Bruno Delgado on 4/23/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "UserSession.h"

@implementation UserSession
@synthesize sessionDictionary = _sessionDictionary;
@synthesize pushNotificationsActivated = _pushNotificationsActivated;

+ (instancetype)sharedInstance
{
    static UserSession *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (NSDictionary *)sessionDictionary
{
    NSDictionary *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"Session"];
    return session;
}

- (void)setSessionDictionary:(NSDictionary *)sessionDictionary
{
    _sessionDictionary = sessionDictionary;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionDictionary forKey:@"Session"];
    [defaults synchronize];
}

- (void)setPushNotificationsActivated:(BOOL)pushNotificationsActivated
{
    _pushNotificationsActivated = pushNotificationsActivated;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:pushNotificationsActivated forKey:@"Push"];
    [defaults synchronize];
    
    if (pushNotificationsActivated)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserSessionPushNotificationsActivated object:nil userInfo:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserSessionPushNotificationsDesactivated object:nil userInfo:nil];
    }
}

- (BOOL)pushNotificationsActivated
{
    BOOL isActive = [[NSUserDefaults standardUserDefaults] boolForKey:@"Push"];
    return isActive;
}

- (void)resetPagination
{
    self.currentPage = @0;
}

@end
