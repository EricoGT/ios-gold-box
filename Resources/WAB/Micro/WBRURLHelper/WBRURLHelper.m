//
//  WBRURLHelper.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRURLHelper.h"

@implementation WBRURLHelper

+ (NSDictionary *)getParameterFromDeepLinkURL:(NSString *)deepLinkURL {
    
    NSMutableDictionary *parametersDictionary = [[NSMutableDictionary alloc] init];
    NSArray<NSString *> *urlComponents = [deepLinkURL componentsSeparatedByString:@"://"];
    
    if (urlComponents.count > 0) {
        
        NSString *parametersString = [urlComponents lastObject];
        NSArray<NSString *> *parametersArray = [parametersString componentsSeparatedByString:@"&"];
        
        [parametersArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSRange equalsRange = [obj rangeOfString:@"="];
            
            if (equalsRange.location != NSNotFound) {
                NSString *parameterKey = [obj substringToIndex:equalsRange.location];
                NSString *parameterValue = [obj substringFromIndex:(equalsRange.location+equalsRange.length)];
                
                [parametersDictionary setObject:parameterValue forKey:parameterKey];
            }
        }];
    }
    
    return parametersDictionary;
}

@end
