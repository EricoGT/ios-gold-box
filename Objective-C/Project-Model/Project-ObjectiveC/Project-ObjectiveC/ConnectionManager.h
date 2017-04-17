//
//  ConnectionManager.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/25/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@protocol ConnectionManagerDelegate <NSObject>

@optional
-(void)didConnectWithSuccess:(NSDictionary *)response;
-(void)didConnectWithFailure:(NSError *)error;
-(void)didConnectWithSuccessData:(NSData *)responseData;
-(void)downloadProgress:(float)dProgress;

@end

@interface ConnectionManager : NSObject <NSURLConnectionDelegate>

@property(nonatomic, assign) id<ConnectionManagerDelegate> delegate;

//+ (id)sharedInstance;
- (BOOL)isConnectionActive;
- (NSString*)getServerPreference;

//exemplos:
- (void)setData:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getData:(long)objectID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

@end
