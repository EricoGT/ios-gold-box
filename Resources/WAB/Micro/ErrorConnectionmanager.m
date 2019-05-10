//
//  ErrorConnectionmanager.m
//  Walmart
//
//  Created by Marcelo Santos on 1/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ErrorConnectionmanager.h"

@implementation ErrorConnectionmanager

+ (NSDictionary *) analyzeResponse:(NSHTTPURLResponse *) response error:(NSError *) error {
    
    NSDictionary *dictResponse = [NSDictionary new];
    
    NSString *msgError = ERROR_CONNECTION_UNKNOWN;
    
    NSString *errorString = error.description ?: @"";
    NSInteger statusCode = [response statusCode] ?: 0;
    
    if ([errorString rangeOfString:@"Code=-1200"].location != NSNotFound)
    {
        statusCode = 1200; //An SSL error has occurred and a secure connection to the server cannot be made
    }
    else if ([errorString rangeOfString:@"Code=-1012"].location != NSNotFound)
    {
        statusCode = 401; //The connection failed because the user cancelled required authentication
    }
    else if ([errorString rangeOfString:@"Code=-1001"].location != NSNotFound)
    {
        statusCode = 408; //The connection timed out
        
        msgError = ERROR_CONNECTION_TIMEOUT;
    }
    else if ([errorString rangeOfString:@"Code=-1003"].location != NSNotFound ||
             [errorString rangeOfString:@"Code=-1004"].location != NSNotFound ||
             [errorString rangeOfString:@"Code=-1005"].location != NSNotFound ||
             [errorString rangeOfString:@"Code=-1009"].location != NSNotFound)
    {
        
        //-1003: The connection failed because the host could not be found
        //-1004: The connection failed because a connection cannot be made to the host
        //-1005: The connection failed because the network connection was lost
        //-1009: The connection failed because the device is not connected to the internet
        
        statusCode = 1009;
        
        msgError = ERROR_CONNECTION_INTERNET;
    }
    else if ((int) statusCode == 0) {
        
        msgError = ERROR_CONNECTION_DATA;
    }
    
    dictResponse = @{@"statusCode"  : [NSNumber numberWithInt:(int)statusCode],
                     @"message"     : msgError
                     };
    
    return dictResponse;
}

@end
