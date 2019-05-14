//
//  WBRPaymentManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kPaymentManagerSuccessBlock)(NSArray *dataArray);
typedef void(^kPaymentManagerFailureBlock)(NSError *error);

typedef void(^kPaymentManagerSuccessStringBlock)(NSString *dataString);
typedef void(^kPaymentManagerFailureStringBlock)(NSError *error, NSString *dataString);

@interface WBRPaymentManager : NSObject

/**
 Get payment withou cart
 
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)postPaymentWithCart:(NSString *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock;

+ (void)postPaymentInstallments:(NSString *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock;

+ (void)postPaymentPlaceOrder:(NSDictionary *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock;

@end
