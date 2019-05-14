//
//  SearchSuggestion.h
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface SearchSuggestion : JSONModel

@property (nonatomic, strong) NSArray<Optional> *suggestions;
@property (nonatomic, strong) NSArray<Optional> *departments;
@property (nonatomic, strong) NSString *suggestedTerm;

@end
