//
//  SellerConnection.h
//  Walmart
//
//  Created by Renan on 7/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@interface SellerConnection : WMBaseConnection

- (void)loadSellerDescriptionWithSellerId:(NSString *)sellerId completionBlock:(void (^)(NSString *sellerName, NSString *sellerDescription))success failure:(void (^)(NSError *error))failure;

@end
