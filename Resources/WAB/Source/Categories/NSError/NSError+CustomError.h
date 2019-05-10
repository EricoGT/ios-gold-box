//
//  NSError+CustomError.h
//  Walmart
//
//  Created by Renan Cargnin on 28/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CustomError)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message failureReason:(NSString *)failureReason;
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;
+ (NSError *)errorWithMessage:(NSString *)message;

@end
