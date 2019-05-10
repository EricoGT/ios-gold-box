//
//  WBRAppFeedbackManager.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/21/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRAppFeedbackManager.h"

#import "WBRConnection.h"
#import "NSError+CustomError.h"

@implementation WBRAppFeedbackManager

+ (void)sendFeedbackWithParameters:(NSDictionary<NSString *, id> *)parameters successBlock:(kAppFeedbackManagerSuccessBlock)successBlock failureBlock:(kAppFeedbackManagerFailure)failureBlock {
    
    LogInfo(@"[WBRAppFeedbackManager] sendFeedbackWithParameters:successBlock:failureBlock: %@", parameters);
    
    NSString *url = [[OFUrls new] getURLSendFeedback];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json"
                                                                 };
    [[WBRConnection sharedInstance] POST:url headers:headersDictionary body:parameters authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        
        LogInfo(@"[WBRAppFeedbackManager] sendFeedbackWithParameters:successBlock:failureBlock: successBlock");
        
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        LogInfo(@"[WBRAppFeedbackManager] sendFeedbackWithParameters:successBlock:failureBlock: failureBlock");
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
