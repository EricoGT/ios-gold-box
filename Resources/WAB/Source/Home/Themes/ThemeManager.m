//
//  ThemeManager.m
//  Walmart
//
//  Created by Bruno on 10/26/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "ThemeManager.h"

static NSString * const kActiveTheme = @"ActiveThemeKey";

@implementation ThemeManager

+ (WalmartTheme *)theme {
    WalmartTheme *theme;
    
    NSData *themeData = [[NSUserDefaults standardUserDefaults] objectForKey:kActiveTheme];
    if (themeData) {
        theme = [NSKeyedUnarchiver unarchiveObjectWithData:themeData];
    }
    else {
        theme = [self defaultTheme];
        [self setTheme:theme];
    }

    return theme;
}

+ (void)setTheme:(WalmartTheme *)theme {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (theme) {
        NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:theme];
        [defaults setObject:themeData forKey:kActiveTheme];
        [defaults synchronize];
    } else {
        NSData *themeData = [NSKeyedArchiver archivedDataWithRootObject:[self defaultTheme]];
        [defaults setObject:themeData forKey:kActiveTheme];
        [defaults synchronize];
    }
}

+ (void)clearTheme {
    [self setTheme:nil];
}

+ (WalmartTheme *)defaultTheme {
    WalmartTheme *theme = [WalmartTheme new];
    theme.backgroundColor = RGBA(245, 245, 245, 1);
    theme.headerColor = RGBA(128, 128, 128, 1);
    theme.pageControlColor = RGBA(216, 216, 216, 1);
    theme.pageControlHighlightColor = RGBA(35, 150, 243, 1);
    return theme;
}

/* Custom themes just for tests */
+ (WalmartTheme *)blackFridayTheme {
    WalmartTheme *theme = [WalmartTheme new];
    theme.backgroundColor = RGBA(24, 25, 27, 1);
    theme.headerColor = RGBA(253, 187, 48, 1);
    theme.pageControlColor = RGBA(216, 216, 216, 1);
    theme.pageControlHighlightColor = RGBA(35, 150, 243, 1);
    return theme;
}

+ (WalmartTheme *)christmasTheme {
    WalmartTheme *theme = [WalmartTheme new];
    theme.backgroundColor = RGBA(197, 20, 22, 1);
    theme.headerColor = RGBA(245, 223, 176, 1);
    theme.pageControlColor = RGBA(216, 216, 216, 1);
    theme.pageControlHighlightColor = RGBA(35, 150, 243, 1);
    return theme;
}

@end
