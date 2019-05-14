//
//  LogError.m
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "LogError.h"

@implementation LogError

- (NSString *)event
{
    if (!_event) {
        return @"EVENT_COMMUNICATION_ERR";
    }
    
    return _event;
}

@end
