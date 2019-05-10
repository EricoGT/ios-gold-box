//
//  OFNotificationsViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 3/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WALMenuItemViewController.h"

@protocol OFNotificationsDelegate <NSObject>
@required
@optional
- (void) hideNotificationsScreen;
- (void) hideNotificationsScreenGesture;
- (void) showNotificationsScreenGesture;
@end

@interface OFNotificationsViewController : WALMenuItemViewController {
    
    __weak id <OFNotificationsDelegate> delegate;
}

@property (weak) id delegate;

@end
