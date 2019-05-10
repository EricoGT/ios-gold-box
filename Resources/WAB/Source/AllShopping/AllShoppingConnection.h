//
//  AllShoppingConnection.h
//  Walmart
//
//  Created by Renan on 7/21/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@interface AllShoppingConnection : WMBaseConnection

- (void)loadAllShoppingWithCompletionBlock:(void (^)(NSArray *categories))success failure:(void (^)(NSError *error))failure;

@end
