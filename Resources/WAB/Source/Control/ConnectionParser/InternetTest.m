//
//  InternetTest.m
//  Walmart
//
//  Created by Marcelo Santos on 5/16/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "InternetTest.h"
#import "Reachability.h"

@implementation InternetTest

+ (BOOL) internetOk {
    
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    NetworkStatus stat = [reach currentReachabilityStatus];
    
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(stat != NotReachable) {
        return YES;
    } else {
        return NO;
    }
}

@end
