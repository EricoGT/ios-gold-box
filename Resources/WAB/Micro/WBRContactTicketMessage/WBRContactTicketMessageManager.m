//
//  WBRContactTicketMessage.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/6/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactTicketMessageManager.h"

#import "WBRConnection.h"
#import "NSError+CustomError.h"
#import "ErrorConnectionmanager.h"
#import <MobileCoreServices/MobileCoreServices.h>

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_TICKETS YES
#else
#define USE_MOCK_TICKETS NO
#endif
// ---------------------------------------------------

@implementation WBRContactTicketMessageManager

+ (void)requestOrderedMessagesFromTickets:(NSString *)ticketId
                             successBlock:(kContactTicketOrderedMessageSuccessCompletionBlock)successBlock
                             failureBlock:(kContactTicketOrderedMessageFailureCompletionBlock)failureBlock  {
    
    LogInfo(@"[WBRContactTicketMessageManager] requestOrderedMessagesFromTickets:successBlock:failureBlock:");
    
    if (USE_MOCK_TICKETS) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatMessages" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }
        
        NSData *messagesData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        
        NSArray <WBRContactTicketMessageModel *> *messages = [WBRContactTicketMessageModel arrayOfModelsFromData:messagesData error:&error];
        
        if (!error) {
            
            if (successBlock) {
                WBRContactTicketOrderedMessagesModel *orderedMessages = [[WBRContactTicketOrderedMessagesModel alloc] initWithMessages:messages];
                
                if (successBlock) {
                    successBlock(orderedMessages);
                }
            }
            
        } else {
            if (failureBlock) {
                failureBlock(error);
            }
        }
        
    } else {
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                     @"Content-Type": @"application/json",
                                                                     @"Accept": @"application/json",
                                                                     @"system": [dictInfo objectForKey:@"system"],
                                                                     @"version": [dictInfo objectForKey:@"version"]
                                                                     };
        
        NSString *ticketMessageUrl = [OFUrls getURLContactTicketCommentsWithTicketId:ticketId];
        
        
        [[WBRConnection sharedInstance] GET:ticketMessageUrl
                                    headers:headersDictionary
                        authenticationLevel:kAuthenticationLevelRequired
                               successBlock:^(NSURLResponse *response, NSData *data) {
                                   
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
                                   LogMicro(@"[TICKET MESSAGES] Status Code: %i", responseStatusCode);
                                   
                                   NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   LogInfo(@"[TICKET MESSAGES] MessagesCollection: %@", dictJson);
                                   
                                   NSError *error;
                                   NSArray <WBRContactTicketMessageModel *> *messages = [WBRContactTicketMessageModel arrayOfModelsFromData:data error:&error];
                                   
                                   if (error) {
                                       if (failureBlock) {
                                           failureBlock(error);
                                       }
                                   }
                                   
                                   WBRContactTicketOrderedMessagesModel *orderedMessages = [[WBRContactTicketOrderedMessagesModel alloc] initWithMessages:messages];
                                   
                                   if (successBlock) {
                                       successBlock(orderedMessages);
                                   }
                               }
                               failureBlock:^(NSError *error, NSData *failureData) {
                                   if (failureBlock) {
                                       failureBlock(error);
                                   }
                               }];
    }
}

+ (void)postMessage:(WBRContactTicketSendMessageModel *)message
         FromTicket:(NSString *)ticketId
   WithSuccessBlock:(kContactTicketPostMessageSuccessCompletionBlock)successBlock
    AndFailureBlock:(kContactTicketPostMessageFailureCompletionBlock)failureBlock {
    
    LogMicro(@"[TICKET SEND MESSAGES]");
    if (USE_MOCK_TICKETS) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sendChatMessageSuccess" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        successBlock(jsonData);
        
    } else {
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                     @"Content-Type": @"application/json",
                                                                     @"Accept": @"application/json",
                                                                     @"system": [dictInfo objectForKey:@"system"],
                                                                     @"version": [dictInfo objectForKey:@"version"]
                                                                     };
        
        NSString *ticketMessageUrl = [OFUrls getURLContactTicketCommentsWithTicketId:ticketId];
        
        LogMicro(@"[TICKET SEND MESSAGES] URL: %@", ticketMessageUrl);
        LogMicro(@"[TICKET SEND MESSAGES] Headers: %@", headersDictionary);
        
        [[WBRConnection sharedInstance] POST:ticketMessageUrl
                                     headers:headersDictionary
                                        body:[message toDictionary]
                         authenticationLevel:kAuthenticationLevelRequired
                                successBlock:^(NSURLResponse *response, NSData *data) {
                                    
                                    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                    LogInfo(@"[TICKET SEND MESSAGES] Returned data: %@", dictJson);
                                    
                                    if (successBlock) {
                                        successBlock(data);
                                    }
                                }
                                failureBlock:^(NSError *error, NSData *failureData) {
                                    
                                    LogInfo(@"[TICKET SEND MESSAGES] Returned data: %@", error.localizedDescription);
                                    
                                    if (failureBlock) {
                                        failureBlock(error);
                                    }
                                }];
    }
    
}

+ (void)uploadAttachment:(NSData *)fileData WithName:(NSString *)fileName ProgressDelegateOwner:(nullable id <NSURLSessionDelegate>)delegate WithSuccessBlock:(kContactTicketPostMessageSuccessCompletionBlock)successBlock
         AndFailureBlock:(kContactTicketPostMessageFailureCompletionBlock)failureBlock  {
    
    NSString *mimeType = [WBRContactTicketMessageManager getMimeTypeFromExtension:[fileName pathExtension]];
    NSString *boundary = [NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSDictionary *headers = @{
                               @"content-type": contentType,
                               @"Authorization": @"Basic d2FsbWFydDpUIWNrM3RIdTY=",
                               @"token": [[[WMTokens alloc] init] getTokenOAuthWithoutRefreshToken].accessToken
                               };
    
    NSString *headerFile = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", boundary, [fileName lastPathComponent], mimeType];
    
    NSString *footerFile = [NSString stringWithFormat:@"\r\n\r\n--%@--\r\n", boundary];
    
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[headerFile dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:fileData];
    [postData appendData:[footerFile dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[OFUrls getURLContactTicketCommentUploadAttachment]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                          delegate:delegate
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *uploadTask = [session uploadTaskWithRequest:request
                                                             fromData:postData
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        if (error) {
                                                            LogInfo(@"[TICKET uploadAttachment failure] Returned data: %@", error.localizedDescription);
                                                            
                                                            if (failureBlock) {
                                                                failureBlock(error);
                                                            }
                                                        } else {
                                                            
                                                            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                            LogInfo(@"[TICKET uploadAttachment success] Returned data: %@", dictJson);
                                                            
                                                            if (successBlock) {
                                                                successBlock(data);
                                                            }
                                                        }
                                                        
                                                    }];
    [uploadTask resume];
    
}

+ (nullable NSString *) getMimeTypeFromExtension:(NSString *)extension {
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFBridgingRetain(extension), nil);
    NSString *mimeType = (__bridge NSString *)UTTypeCopyPreferredTagWithClass (uti, kUTTagClassMIMEType);
    
    return mimeType;
}

+ (void)downloadAttachment:(NSString *)attachmentId fromTicketId:(NSString *)ticketId andCommentId:(NSString *)commentId ProgressDelegateOwner:(nullable id <NSURLSessionDelegate>)delegate {
    

    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                          delegate:delegate
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[OFUrls getURLContactTicketCommentDownloadAttachmentWithAttachmentId:attachmentId andTicketId:ticketId andCommentId:commentId]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:@{
                                      @"Authorization": @"Basic d2FsbWFydDpUIWNrM3RIdTY=",
                                      @"token": [[[WMTokens alloc] init] getTokenOAuthWithoutRefreshToken].accessToken
                                      }];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
}

@end
