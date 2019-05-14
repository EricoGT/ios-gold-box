//
//  WBRSearchManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRSearchManager.h"
#import "WBRConnection.h"

@implementation WBRSearchManager

+ (void)getSearchSuggestionsWithQuery:(NSString *)query completionBlock:(kSearchManagerSuccessBlock)success failureBlock:(kSearchManagerFailureBlock)failure {
    
    LogInfo(@"[WBRSearchManager] getSearchSuggestionWithQuery:query:success:failure:");

    NSString *escapedQueryString = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat: [[OFUrls new] getURLSuggestions], escapedQueryString];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    NSDictionary <NSString *, NSString *> *headersDictionary = @{
                                                                 @"Content-Type": @"application/json",
                                                                 @"Accept": @"application/json",
                                                                 @"system": [dictInfo objectForKey:@"system"],
                                                                 @"version": [dictInfo objectForKey:@"version"]
                                                                 };
    
    [[WBRConnection sharedInstance] GET:urlString headers:headersDictionary authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *suggestionsParserError;
        
        SearchSuggestion *suggestionResult = [[SearchSuggestion alloc] initWithString:responseString error:&suggestionsParserError];
        if (success)
            success(suggestionResult);
        
    } failureBlock:^(NSError *error, NSData *failureData) {
        failure(error);
    }];
}

@end
