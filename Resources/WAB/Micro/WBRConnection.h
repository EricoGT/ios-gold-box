//
//  WBRConnection.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/14/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kAuthenticationLevelNotRequired,
    kAuthenticationLevelOptional,
    kAuthenticationLevelRequired,
} kAuthenticationLevel;

typedef void(^kConnectionSuccessBlock)(NSURLResponse *response, NSData *data);
typedef void(^kConnectionFailureBlock)(NSError *error, NSData *failureData);
typedef void(^kConnectionRawBlock)(NSURLResponse *response, NSData *data, NSError *error);

@interface WBRConnection : NSObject

+ (instancetype)sharedInstance;

- (void)GET:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;
- (void)GET:(NSString *)path headers:(NSDictionary <NSString *, NSString *> *)headers authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;

- (void)POST:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;
- (void)POST:(NSString *)path headers:(NSDictionary <NSString *, NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;
- (void)POST:(NSString *)path headers:(NSDictionary <NSString *, NSString *> *)headers bodyString:(NSString *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;

- (void)PUT:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;
- (void)PUT:(NSString *)path headers:(NSDictionary <NSString *, NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;

- (void)DELETE:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;
- (void)DELETE:(NSString *)path headers:(NSDictionary <NSString *, NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock;

/**
 Method used for calls only from WMBaseConnection

 @param request to be performed
 @param completionBlock called when the request returns
 */
- (void)runRawRequest:(NSURLRequest *)request completionBlock:(kConnectionRawBlock)completionBlock;

@end
