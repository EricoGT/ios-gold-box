//
//  WBRContactTicketMessage.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRContactTicketOrderedMessagesModel.h"
#import "WBRContactTicketSendMessageModel.h"

typedef void(^kContactTicketOrderedMessageSuccessCompletionBlock)(WBRContactTicketOrderedMessagesModel *messages);
typedef void(^kContactTicketOrderedMessageFailureCompletionBlock)(NSError *error);
typedef void(^kContactTicketPostMessageSuccessCompletionBlock)(NSData *data);
typedef void(^kContactTicketPostMessageFailureCompletionBlock)(NSError *error);

@interface WBRContactTicketMessageManager : NSObject

+ (void)requestOrderedMessagesFromTickets:(NSString *)ticketId
                             successBlock:(kContactTicketOrderedMessageSuccessCompletionBlock)successBlock
                             failureBlock:(kContactTicketOrderedMessageFailureCompletionBlock)failureBlock;

+ (void)postMessage:(WBRContactTicketSendMessageModel *)message
         FromTicket:(NSString *)ticketId
   WithSuccessBlock:(kContactTicketPostMessageSuccessCompletionBlock)successBlock
    AndFailureBlock:(kContactTicketPostMessageFailureCompletionBlock)failureBlock;

+ (void)uploadAttachment:(NSData *)fileData WithName:(NSString *)fileName ProgressDelegateOwner:(nullable id <NSURLSessionDelegate>)delegate WithSuccessBlock:(kContactTicketPostMessageSuccessCompletionBlock)successBlock
         AndFailureBlock:(kContactTicketPostMessageFailureCompletionBlock)failureBlock;

+ (void)downloadAttachment:(NSString *)attachmentId fromTicketId:(NSString *)ticketId andCommentId:(NSString *)commentId ProgressDelegateOwner:(nullable id <NSURLSessionDelegate>)delegate;

@end
