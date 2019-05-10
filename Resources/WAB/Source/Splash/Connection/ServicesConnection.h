//
//  ServicesConnection.h
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

#import "ServicesModel.h"

@interface ServicesConnection : WMBaseConnection

- (void)loadServicesWithCompletionBlock:(void (^)(ServicesModel *services))success failure:(void (^)(NSError *error))failure;

@end
