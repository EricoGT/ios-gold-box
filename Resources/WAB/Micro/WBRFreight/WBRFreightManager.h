//
//  WBRFreightManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/08/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kFreightManagerSuccessBlock)(NSArray *dataArray);
typedef void(^kFreightManagerFailureBlock)(NSError *error);

@interface WBRFreightManager : NSObject

/**
 Get the freight value
 
 @param zipCode zip code for calculate
 @param sku sku from product
 @param successBlock success response
 @param failureBlock failura response
 */
+ (void)getFreightWithZipcode:(NSString *)zipCode standardSku:(NSString *)sku success:(kFreightManagerSuccessBlock)successBlock failure:(kFreightManagerFailureBlock)failureBlock;

@end
