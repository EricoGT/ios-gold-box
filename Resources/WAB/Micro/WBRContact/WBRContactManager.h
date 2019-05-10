//
//  WBRContactManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRContactRequestFormModel.h"
#import "WBRContactRequestOrdersArrayModel.h"
#import "WBRContactRequestDeliveryModel.h"
#import "WBRContactRequestExchangeModel.h"

@interface WBRContactManager : NSObject

typedef void(^kContactManagerSubjectsSuccessBlock)(WBRContactRequestFormModel *subjects);
typedef void(^kContactManagerOrdersSuccessBlock)(WBRContactRequestOrdersArrayModel *orders);
typedef void(^kContactManagerDeliveriesSuccessBlock)(NSArray<WBRContactRequestDeliveryModel *> *deliveries);
typedef void(^kContactManagerExchangeSuccessBlock)(WBRContactRequestExchangeModel *exchange);
typedef void(^kContactManagerBanksSuccessBlock)(NSArray<Bank *> *banks);
typedef void(^kContactManagerOrderDetailsSuccessBlock)(BOOL canceled, BOOL hasWarranty);
typedef void(^kContactManagerOpenTicketSuccessBlock)(NSString *ticketNumber);

typedef void(^kContactManagerFailureBlock)(NSError *error);

/**
 Get the contact subjects available on API

 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getContactSubjectsWithAuthentication:(BOOL)authentication success:(kContactManagerSubjectsSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;



/**
 Get the availables orders by the user

 @param extendWarranty if the orders could be with extend warranty
 @param notCancelledOrders filter the order with NotCancelled
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getOrdersWithExtendWarranty:(BOOL)extendWarranty andFilterByNotCancelled:(BOOL)notCancelledOrders success:(kContactManagerOrdersSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;


/**
 Get the deliveries available for the order number id

 @param orderId order number Id
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getDeliveriesWithOrderId:(NSString *)orderId success:(kContactManagerDeliveriesSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;

/**
 Get the exchange by the order and the seller id

 @param orderId order id
 @param sellerId seller id
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getExchangeWithOrderId:(NSString *)orderId andSellerId:(NSString *)sellerId success:(kContactManagerExchangeSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;


/**
Get the bank list

 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)getBanksWithSuccess:(kContactManagerBanksSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;


/**
 Get Order details by order id

 @param orderId order Id
 @param success success block
 @param failure failure block
 */
+ (void)getOrderDetailsByOrderId:(NSString *)orderId success:(kContactManagerOrderDetailsSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;


/**
 Open a ticket with a contact form (POST)

 @param contactDict contact dict with options
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)openTicketWithDictionary:(NSDictionary *)contactDict success:(kContactManagerOpenTicketSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock;

@end
