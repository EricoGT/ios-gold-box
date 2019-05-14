//
//  OFSplashTemp.h
//  Walmart
//
//  Created by Marcelo Santos on 2/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFSplashTemp : NSObject 

+ (void) assignSplashDictionary:(NSDictionary *) dict;
+ (NSDictionary *) getSplashDictionary;
+ (NSString *) getColorSplash;

@end
