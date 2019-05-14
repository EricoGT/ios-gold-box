//
//  ThemeManager.h
//  Walmart
//
//  Created by Bruno on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalmartTheme.h"

@interface ThemeManager : NSObject

+ (WalmartTheme *)theme;
+ (void)setTheme:(WalmartTheme *)theme;
+ (void)clearTheme;

+ (WalmartTheme *)defaultTheme;

/* Custom themes just for tests */
+ (WalmartTheme *)blackFridayTheme;
+ (WalmartTheme *)christmasTheme;


@end
