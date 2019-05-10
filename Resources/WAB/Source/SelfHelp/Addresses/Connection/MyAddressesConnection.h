//
//  MyAddressesConnection.h
//  Walmart
//
//  Created by Renan on 5/15/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@class AddressModel, ZipCodeModel;

@interface MyAddressesConnection : WMBaseConnection

- (void)addAddress:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)updateAddress:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)setAddressAsDefaultWithAddressId:(AddressModel *)address completionBlock:(void (^)())success failure:(void (^)(NSError *))failure;
- (void)loadMyAddressesWithCompletionBlock:(void (^)(NSArray *addresses, NSTimeInterval executionTime))success failure:(void (^)(NSError *error))failure;
- (void)deleteAddressWithAddressId:(NSString *)addressId completionBlock:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)getZipCodeData:(NSString *)zipCode completionBlock:(void (^)(ZipCodeModel *zipCode))success failure:(void (^)(NSString *error))failure;

@end
