//
//  WALSession.h
//  Walmart
//
//  Created by Bruno Delgado on 6/28/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMTokens.h"

@interface WALSession : NSObject

/**
 *  Checks the user authentication status based on the oAuth token store locally
 *
 *  @return The authentication status
 */
+ (BOOL)isAuthenticated;

@end
