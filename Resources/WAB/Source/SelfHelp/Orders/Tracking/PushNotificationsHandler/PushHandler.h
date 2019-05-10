//
//  PushHandler.h
//  Tracking
//
//  Created by Bruno Delgado on 26/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *OrderUpdatePushNotification = @"OrderUpdatePushNotification";
static NSString *ProductPushNotification = @"ProductPushNotification";

static NSString *OrderIDKey = @"OrderIDKey";
static NSString *SKUKey = @"SKUNumber";

@interface PushHandler : NSObject

@property (nonatomic, strong) NSDictionary *notificationDictionary;

+ (instancetype)singleton;
+ (void)destroy;

- (void)registerForPushNotifications;
- (void)unregisterForPushNotifications;
- (void)handlePushReceived:(NSDictionary *)userInfo;
- (void)cleanBadge;

- (void)registerForPushNotificationsOnWalmartServer;
- (void)unregisterForPushNotificationsOnWalmartServer;

- (BOOL)isHomePushNotification;
- (NSString *)productIdFromNotification;
- (NSString *)productSKUFromNotification;
- (NSString *)orderIDFromPushNotification;
- (NSString *)collectionFromPushNotification;

@end
