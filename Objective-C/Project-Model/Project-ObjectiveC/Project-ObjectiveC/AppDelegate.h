//
//  AppDelegate.h
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#import "ToolBox.h"
#import "ConstantsManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Aux Methods

- (NSString*)STR:(NSString*)key;
- (long)RandomIntWithStart:(long)startNumber end:(long)endNumber;
- (float)RandomNumber;

@end

