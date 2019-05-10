//
//  FilterConnection.h
//  Walmart
//
//  Created by Bruno Delgado on 11/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"

@class Filter;
@class SearchCategoryResult;

@interface FilterConnection : WMBaseConnection <NSURLConnectionDelegate>


- (void)filterWithQuery:(NSString *)query completionBlock:(void (^)(SearchCategoryResult *result))success failureBlock:(void (^)(NSError *error))failure;

@end
