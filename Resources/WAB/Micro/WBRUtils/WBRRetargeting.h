//
//  WBRRetargeting.h
//  Walmart
//
//  Created by Marcelo Santos on 4/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBRRetargeting : NSObject

/**
 Send information to retargeting. Asynchronous request.

 @param strUrl Url customized with parameters.
 @param success NSHTTPURLResponse response.
 @param failure Failure reason with error message and status code. If there is an error with model, a dictionary @{@"error" : @"Model error"} is returned.
 */
- (void) retargetingShowcases:(NSString *) strUrl success:(void (^)(NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure;

@end
