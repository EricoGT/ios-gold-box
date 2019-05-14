//
//  OrderDetailConnection.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "WMBaseConnection.h"
#import "Order.h"
#import "TrackingOrderDetail.h"

@interface OrderDetailConnection : WMBaseConnection

#pragma mark - Methods
+ (instancetype)sharedInstance;
- (void)getDetailsFromOrder:(Order *)order completionBlock:(void (^)(TrackingOrderDetail *details))success failureBlock:(void (^)(NSError *error))failure;

@end
