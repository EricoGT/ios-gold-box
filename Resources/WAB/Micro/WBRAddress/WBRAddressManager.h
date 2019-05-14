//
//  WBRAddressManager.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/18/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBRCheckoutAddressModel.h"

typedef void(^kAddressManagerSuccessBlock)(void);
typedef void(^kAddressManagerFailureBlock)(NSError *error);

typedef void(^kAddressManagerShipmentSuccessBlock)(NSNumber *price);
typedef void(^kAddressManagerShipmentFailureBlock)(NSError *error, NSData *responseError);

@interface WBRAddressManager : NSObject

+ (void)newAddress:(WBRCheckoutAddressModel *)addressModel successBlock:(kAddressManagerSuccessBlock)successBlock failureBlock:(kAddressManagerFailureBlock)failureBlock;
+ (void)updateAddress:(WBRCheckoutAddressModel *)addressModel forAddressId:(NSString *)addressId successBlock:(kAddressManagerSuccessBlock)successBlock failureBlock:(kAddressManagerFailureBlock)failureBlock;
+ (void)getShipmentOptionsForZipcode:(NSString *)zipcode sucessBlock:(kAddressManagerShipmentSuccessBlock)successBlock failureBlock:(kAddressManagerShipmentFailureBlock)failureBlock;

@end
