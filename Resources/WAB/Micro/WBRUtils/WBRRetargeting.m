//
//  WBRRetargeting.m
//  Walmart
//
//  Created by Marcelo Santos on 4/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRRetargeting.h"
#import "WBRRetargetingConnection.h"

@implementation WBRRetargeting

- (void) retargetingShowcases:(NSString *) strUrl success:(void (^)(NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure {
    
    [[WBRRetargetingConnection new] requestRetargShowcases:strUrl success:^(NSHTTPURLResponse *httpResponse) {
        
        if (success) success(httpResponse);
        
    } failure:^(NSDictionary *dictError) {
        
        if (failure) failure (dictError);
    }];
}

@end
