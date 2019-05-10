//
//  UserSession.h
//  Tracking
//
//  Created by Bruno Delgado on 4/23/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *UserSessionPushNotificationsActivated = @"PushOn";
static NSString *UserSessionPushNotificationsDesactivated = @"PushOff";

@interface UserSession : NSObject

@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSDictionary *sessionDictionary;
@property (nonatomic, assign) BOOL pushNotificationsActivated;

+ (instancetype)sharedInstance;

#pragma mark - Pagination
- (void)resetPagination;



@end
