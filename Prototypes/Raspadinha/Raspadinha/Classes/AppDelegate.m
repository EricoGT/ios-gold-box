//
//  AppDelegate.m
//  Raspadinha
//
//  Created by lordesire on 10/01/2018.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (SCLAlertViewPlus*)createDefaultAlert
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindowWidth:[UIScreen mainScreen].bounds.size.width - 160.0];
    [alert.labelTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [alert.viewText setFont:[UIFont systemFontOfSize:16.0]];
    [alert setButtonsTextFontFamily:[UIFont boldSystemFontOfSize:16.0].fontName withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    return alert;
}

//- (SCLAlertViewPlus*)createLargeAlert
//{
//    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindowWidth:[UIScreen mainScreen].bounds.size.width - 160.0];
//    [alert.labelTitle setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_SEMIBOLD size:20.0]];
//    [alert.viewText setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_REGULAR size:16.0]];
//    [alert setButtonsTextFontFamily:FONT_MYRIAD_PRO_SEMIBOLD withSize:16.0];
//    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
//    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
//    alert.backgroundType = SCLAlertViewBackgroundShadow;
//    return alert;
//}

@end
