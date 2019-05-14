//
//  CartConnection.h
//  Walmart
//
//  Created by Renan Cargnin on 07/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBaseConnection.h"

@interface CartConnection : WMBaseConnection

+ (void)submitCouponWithRedemptionCode:(NSString *)redemptionCode successBlock:(void (^)(NSDictionary *cart, NSDictionary *errorDict))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
+ (void)removeCouponWithRedemptionCode:(NSString *)redemptionCode successBlock:(void (^)(NSDictionary *cart, NSDictionary *errorDict))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

@end
