//
//  NSError+CustomError.m
//  Walmart
//
//  Created by Renan Cargnin on 28/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "NSError+CustomError.h"

static NSString *kWalmartErrorDomain = @"com.Walmart";

@implementation NSError (CustomError)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message failureReason:(NSString *)failureReason {
    
    NSDictionary *userInfoDictionary = @{
                                         NSLocalizedDescriptionKey: message ?: @"",
                                         NSLocalizedFailureReasonErrorKey: failureReason ?: @""
                                         };
    
    return [NSError errorWithDomain:kWalmartErrorDomain code:code userInfo:userInfoDictionary];
}

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:kWalmartErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

+ (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithCode:0 message:message];
}

@end
