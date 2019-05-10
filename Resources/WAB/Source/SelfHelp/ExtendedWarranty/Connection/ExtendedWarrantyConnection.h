//
//  ExtendedWarrantyConnection.h
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@class ExtendedWarrantyDetail;
@class ExtendedWarrantyCancelData;

@interface ExtendedWarrantyConnection : WMBaseConnection

- (void)loadExtendedWarrantiesWithPageNumber:(NSUInteger)pageNumber completionBlock:(void (^)(NSArray *warranties))success failure:(void (^)(NSError *error))failure;
- (void)getExtendedWarrantyDetailForTicketNumber:(NSString *)ticketNumber completionBlock:(void (^)(ExtendedWarrantyDetail *warranty))success failure:(void (^)(NSError *error))failure;
- (void)getExtendedWarrantiesCancelOptionsForOrderNumber:(NSNumber *)orderNumber completionBlock:(void (^)(ExtendedWarrantyCancelData *cancelData))success failure:(void (^)(NSError *error))failure;
- (void)cancelExtendedWarranty:(NSDictionary *)cancelDictionary completionBlock:(void (^)(NSNumber *protocol))success failure:(void (^)(NSError *error))failure;

@end
