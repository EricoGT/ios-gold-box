//
//  FilterConnection.m
//  Walmart
//
//  Created by Bruno Delgado on 11/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "FilterConnection.h"
#import "Filter.h"
#import "SearchCategoryResult.h"
#import "OFSetup.h"

#import "WBRProduct.h"

//#define timeoutRequest 50.0f

@implementation FilterConnection

- (void)filterWithQuery:(NSString *)query completionBlock:(void (^)(SearchCategoryResult *result))success failureBlock:(void (^)(NSError *error))failure
{
    
    [[WBRProduct new] getSearchWithQuery:query sortParameter:@"" successBlock:^(NSData *dataJson) {
        
//        //Transform data from server to NSDictionary
//        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataJson options:kNilOptions error:nil];
        NSError *parserError;
        SearchCategoryResult *result = [[SearchCategoryResult alloc] initWithData:dataJson error:&parserError];
        if (result) {
            success(result);
        }
        else {
            if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
        }
        
    } failureBlock:^(NSDictionary *dictError) {
        
        if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
    }];
    
    
////    query = [query stringByReplacingOccurrencesOfString:@"?" withString:@""];
//    query = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSString *escapedURLString = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //    escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"?" withString: @""];
//    escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"?fq" withString: @"fq"];
//    escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"amp;" withString: @""];
//    escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
//    
//    NSURL *url = [OFUrls urlWithAppVersion:2 pathComponents:@[@"search", escapedURLString ?: @""]];
//    
//    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
//    req.timeoutInterval = timeoutRequest;
//    [req setHTTPMethod:@"GET"];
//    
//    if (!req.allHTTPHeaderFields[@"token"])
//    {
//        WMTokens *tkManager = [WMTokens new];
//        WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
//        if (tkUs.accessToken.length > 0)
//        {
//            //[tkManager refreshTokenInBackground:tkUs];
//            [req setValue:tkUs.accessToken forHTTPHeaderField:@"token"];
//        }
//    }
//    
//    [self run:req authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
//        NSError *parserError;
//        SearchCategoryResult *result = [[SearchCategoryResult alloc] initWithModelToJSONDictionary:json error:&parserError];
//        if (result)
//        {
//            if (success) success(result);
//        }
//        else
//        {
//            if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
//        }
//    } failure:^(NSError *error, NSData *data) {
//        if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
//    }];
}

@end
