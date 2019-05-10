//
//  WMBlockVersion.h
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServicesMessageModel;

@interface WMBlockVersion : NSObject

@property (strong, nonatomic) ServicesMessageModel *message;

- (WMBlockVersion *)initWithWithCompletionBlock:(void (^)(ServicesMessageModel *messageModel))success failure:(void (^)(NSError *error))failure;

@end
