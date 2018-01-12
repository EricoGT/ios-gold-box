//
//  AppDelegate.h
//  Raspadinha
//
//  Created by lordesire on 10/01/2018.
//  Copyright © 2018 lordesire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLAlertViewPlus.h"

#define AppD ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (SCLAlertViewPlus*)createDefaultAlert;

@end

