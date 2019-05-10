//
//  MDSTime.h
//  Walmart
//
//  Created by Marcelo Santos on 3/22/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

@interface MDSTime : NSObject

+ (void)start:(NSString *)name;
+ (void)stop:(NSString *)name;

@end
