//
//  OFSplashTemp.m
//  Walmart
//
//  Created by Marcelo Santos on 2/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFSplashTemp.h"

@implementation OFSplashTemp

static NSDictionary *dictSplash;

+ (void) assignSplashDictionary:(NSDictionary *) dict {
    
    dictSplash = [[NSDictionary alloc] initWithDictionary:dict];
}


+ (NSDictionary *) getSplashDictionary {
    
    return dictSplash;
}

+ (NSString *) getColorSplash {
    
    NSArray *arrTp = [dictSplash objectForKey:@"bgColor"];
    
    NSString *rgba = @"2,124,195,255";
    
    if ([arrTp count] >=4) {
        
        NSString *r = [arrTp objectAtIndex:0];
        NSString *g = [arrTp objectAtIndex:1];
        NSString *b = [arrTp objectAtIndex:2];
        NSString *a = [arrTp objectAtIndex:3];
        
        rgba = [NSString stringWithFormat:@"%@,%@,%@,%@", r, g, b, a];
    }
    
    return rgba;
}


@end
