//
//  ErrorConnectionmanager.h
//  Walmart
//
//  Created by Marcelo Santos on 1/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorConnectionmanager : NSObject


/**
 Analyze all requests responses

 @param response NSHTTPURLResponse returned by server
 @param error NSError returned by server
 @return NSDictionary with keys: statusCode and message
 */
+ (NSDictionary *) analyzeResponse:(NSHTTPURLResponse *) response error:(NSError *) error;

@end
