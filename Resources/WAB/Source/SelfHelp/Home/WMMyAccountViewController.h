//
//  WMMyAccountViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 4/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALMenuItemViewController.h"
@class Order;

@interface WMMyAccountViewController : WALMenuItemViewController

//public for tests
@property (nonatomic, strong) Order *orderFromPush;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;

- (void)updateUserGender:(NSString *)gender;
- (void)willLogoutNotification;
- (void)checkOrderPushNotification;

@end
