//
//  SellerConnection.m
//  Walmart
//
//  Created by Renan on 7/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "SellerConnection.h"

@implementation SellerConnection

- (void)loadSellerDescriptionWithSellerId:(NSString *)sellerId completionBlock:(void (^)(NSString *, NSString *))success failure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLSellerDescriptionWithSellerId:sellerId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSString *sellerName = json[@"sellerName"];
        NSString *sellerDescription = json[@"description"];
        
        if (sellerDescription.length > 0) {
            if (success) success(sellerName, sellerDescription);
        }
        else {
            if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
        }
        
    } failure:^(NSError *error, NSData *data) {
        if (failure) failure([WMBaseConnection errorWithCode:error.code message:ERROR_CONNECTION_DATA_ERROR_JSON]);
    }];
}

@end
