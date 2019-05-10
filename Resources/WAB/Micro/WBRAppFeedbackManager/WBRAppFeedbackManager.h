//
//  WBRAppFeedbackManager.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/21/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kAppFeedbackManagerSuccessBlock)(void);
typedef void(^kAppFeedbackManagerFailure)(NSError *error);

@interface WBRAppFeedbackManager : NSObject

+ (void)sendFeedbackWithParameters:(NSDictionary<NSString *, id> *)parameters successBlock:(kAppFeedbackManagerSuccessBlock)successBlock failureBlock:(kAppFeedbackManagerFailure)failureBlock;

@end
