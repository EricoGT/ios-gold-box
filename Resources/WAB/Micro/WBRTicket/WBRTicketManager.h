//
//  WBRContactTicketConnection.h
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRModelTicketCollection.h"
#import "WBRModelTicket.h"

@interface WBRTicketManager : NSObject

/**
 Retrieves the Wallet object associated with the currently logged in user
 The method uses the user token to retrieve the Wallet
 
 @param pageNumber this service is paginated
 @param success WBRModelTicketCollection
 @param failure NSError and NSData
 */
+ (void)getUserTicketsForPageNumber:(NSNumber *)pageNumber
                        withSuccess:(void (^)(NSArray<WBRModelTicket *> *ticketCollection))success
                         andFailure:(void (^)(NSError *error, NSData *data))failure;
/**
 Reopens the ticket with the given commentary
 
 @param ticketId to be reopened
 @param descriptionString of why the user need the ticket to be reopened
 @param success NSData
 @param failure NSError and NSData
 */
+ (void)reopenUserTicketWithTicketId:(NSString *)ticketId
                      andDescription:(NSString *)userDescription
                         withSuccess:(void (^)(NSData *data))success
                          andFailure:(void (^)(NSError *error, NSData *dataError))failure;


/**
 Finalize the ticket with the given commentary

 @param ticketId ticketId to be closed
 @param userDescription user comment
 @param success success NSData
 @param failure NSError and NSData
 */
+ (void)closeUserTicketWithTicketId:(NSString *)ticketId
                      andDescription:(NSString *)userDescription
                         withSuccess:(void (^)(NSData *data))success
                          andFailure:(void (^)(NSError *error, NSData *dataError))failure;

@end
