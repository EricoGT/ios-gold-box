//
//  CategoriesConnection.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@class SearchCategoryResult;

@interface CategoriesConnection : WMBaseConnection <NSURLConnectionDelegate>

@property (nonatomic) NSMutableArray *searchResults;

- (void)getCategoriesWithQuery:(NSString *)query
                 sortParameter:(NSString *)sortParam
               completionBlock:(void (^)(id result))success failureBlock:(void (^)(NSError *error))failure;

@end
