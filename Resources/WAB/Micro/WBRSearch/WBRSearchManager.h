//
//  WBRSearchManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchSuggestion.h"

@interface WBRSearchManager : NSObject

typedef void(^kSearchManagerSuccessBlock)(SearchSuggestion *searchSuggestion);
typedef void(^kSearchManagerFailureBlock)(NSError *error);

+ (void)getSearchSuggestionsWithQuery:(NSString *)query completionBlock:(kSearchManagerSuccessBlock)success failureBlock:(kSearchManagerFailureBlock)failure;

@end
