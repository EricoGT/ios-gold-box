//
//  OrderConnection.h
//  Tracking
//
//  Created by Bruno Delgado on 4/17/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "WMBaseConnection.h"

@class TrackingEntity;

@interface TrackingConnection : WMBaseConnection

#pragma mark - Methods
+ (instancetype)sharedInstance;
- (void)getTrackingInformationFromCurrentUserWithCompletionBlock:(void (^)(TrackingEntity *trackingInfo))success failureBlock:(void (^)(NSError *error))failure;

@end
