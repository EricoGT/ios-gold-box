//
//  WMBaseConnection.h
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBaseConnection : NSObject

@property (assign, nonatomic) BOOL useMock;
@property (strong, nonatomic) NSString *currentMockJSONStr;
@property (assign, nonatomic) BOOL forceFailure;

/**
 *  Use this method to run a request from every part of the Walmart application
 *
 *  @param request Request to be run
 *  @param BOOL value to indicate if this request should be authenticated with a token
 *  @param success Success block when request is over
 *  @param failure Failure block when request is over
 */
- (void)run:(NSMutableURLRequest *)request authenticate:(BOOL)authenticate completionBlock:(void (^)(NSDictionary *json, NSHTTPURLResponse *response))success failure:(void (^)(NSError *error, NSData *data))failure;

/**
 *  Check if there's an active connection
 *
 *  @return BOOL value indicating wheter or not there's an active connection
 */
+ (BOOL)hasInternetConnection;

/**
 *  Helper method to create NSError for Walmart connection errors
 *
 *  @param code    NSInteger with an error code
 *  @param message NSString with an error message
 *
 *  @return NSError object
 */
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;
- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;

/**
 *  Helper method to create NSError for Walmart connection errors
 *
 *  @param message NSString with an error message
 *
 *  @return NSError object
 */
+ (NSError *)errorWithMessage:(NSString *)message;
- (NSError *)errorWithMessage:(NSString *)message;

/**
 *  Returns a BOOL value indicating if the connection should throws failure block wihtout running the request
 *
 *  @return BOOL value to check if connection throws a failur
 */
+ (BOOL)forceErrorMock;

/**
 *  Defines if the connection should throws failure block wihtout running the request
 *
 *  @param forceError BOOL value indicating if the connection should force the error
 */
+ (void)setForceErrorMock:(BOOL)forceError;


@end
