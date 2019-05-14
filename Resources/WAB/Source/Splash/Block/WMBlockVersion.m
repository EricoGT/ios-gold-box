//
//  WMBlockVersion.m
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBlockVersion.h"

#import "ServicesMessageModel.h"
#import "ServicesConnection.h"
#import "WALMenuViewController.h"

@interface WMBlockVersion ()

@end

@implementation WMBlockVersion

- (WMBlockVersion *)initWithWithCompletionBlock:(void (^)(ServicesMessageModel *))success failure:(void (^)(NSError *))failure {
    self = [super init];
    if (self) {
        
        [MDSTime start:@"services"];
        
//        [[ServicesConnection new] loadServicesWithCompletionBlock:^(ServicesModel *services) {
//            [[WALMenuViewController singleton] setServices:services];
//            [[WALMenuViewController singleton] updateDepartments];
//            if (success) success(services.message);
//            
//        } failure:^(NSError *error) {
//            if (failure) failure(error);
//        }];
    }
    
    [MDSTime stop:@"services"];
    
    return self;
}

@end
