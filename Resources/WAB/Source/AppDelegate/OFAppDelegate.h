//
//  OFAppDelegate.h
//  Ofertas
//
//  Created by Marcelo dos Santos on 7/11/13.
//  Copyright (c) 2013-2014 Marcelo dos Santos. All rights reserved..
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>
#import "ModelAlert.h"

@class OFSplashViewController;

@interface OFAppDelegate : UIResponder <UIApplicationDelegate, BITCrashManagerDelegate, BITHockeyManagerDelegate, BITUpdateManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OFSplashViewController *viewController;

//- (void)resetAppToFirstController;
//- (NSString *) testExample;
- (void)dismissModalViews;
- (void) checkAlert:(void (^)(ModelAlert *modelAlert)) success;

//#if !defined CONFIGURATION_Release
//- (NSString *) calabashBackdoor:(NSString *)aIgnorable;
//#endif

@end
