    //
//  CategoriesConnection.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "CategoriesConnection.h"
#import "SearchCategoryResult.h"
#import "OFUrls.h"

#import "WBRProduct.h"

//#define timeoutRequest 50.0f


@implementation CategoriesConnection

- (void)getCategoriesWithQuery:(NSString *)query sortParameter:(NSString *)sortParam completionBlock:(void (^)(id result))success failureBlock:(void (^)(NSError *error))failure {
    
    [[WBRProduct new] getSearchWithQuery:query sortParameter:sortParam successBlock:^(NSData *dataJson) {
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataJson options:kNilOptions error:nil];
        NSError *parserError;
        SearchCategoryResult *result = [[SearchCategoryResult alloc] initWithDictionary:dictJson error:&parserError];
        if (result) {
            success(result);
        }
        else {
            if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
        }
        
    } failureBlock:^(NSDictionary *dictError) {
        
        if (failure) failure([self errorWithMessage:[[OFMessages new] errorConnectionInvalidData]]);
    }];
}

@end
