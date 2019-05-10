//
//  HubConnection.h
//  Walmart
//
//  Created by Renan on 7/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@interface HubConnection : WMBaseConnection

- (void)loadHubCategoriesWithHubId:(NSString *)hubId loadSubmenu:(BOOL)loadSubmenu completionBlock:(void (^)(NSArray *categories, NSArray *otherCategories))success failure:(void (^)(NSError *error))failure;
- (void)loadOffersWithHubId:(NSString *)hubId completionBlock:(void (^)(NSArray *products))success failure:(void (^)(NSError *error))failure;

@end
